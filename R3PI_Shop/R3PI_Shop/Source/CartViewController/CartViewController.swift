//
//  CartViewController.swift
//  R3PI_Shop
//
//  Created by Anatoli Benke on 24.06.17.
//  Copyright © 2017 Private. All rights reserved.
//

import UIKit
import CoreData

enum CartMode {
    case modify, checkout
}

class CartViewController: UIViewController {
    
    //==========================================================================
    //MARK:- Constants
    //==========================================================================
    
    struct Constants {
        static let StoryBoardIdentifier         = "Main"
        static let CartViewControllerIdentifier = "CartViewController"
        
        static let TabletViewHeightMultiplier : CGFloat = 0.75
        static let TabletViewWidthMultiplier  : CGFloat = 0.6
    }
    //==========================================================================
    //MARK:- Outlets
    //==========================================================================
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    //==========================================================================
    //MARK:- Variables
    //==========================================================================
    
    lazy var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: CartItem.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "product.title", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    var mode: CartMode = .modify {
        didSet {
            switch mode {
            case .modify:
                self.tableView.tableHeaderView = nil
                self.setupCheckoutButton()
                break
            case .checkout:
                self.tableView.tableHeaderView = self.setupCheckoutHeaderView()
                self.navigationItem.rightBarButtonItems = nil
            }
            
            self.tableView.reloadData()
        }
    }
    
    var checkoutHeaderView: CheckoutHeaderView?
    var cartCurrencyCode: String = CurrencyManager.sharedInstance.sourceCurrency ?? "USD"
    
    var currencyPickerViewController: CurrencyPickerViewController?
    
    // ==========================================================================
    // MARK: - UIViewController Methods
    // ==========================================================================

    class func newInstance() -> CartViewController {
        let controller = UIStoryboard(name: Constants.StoryBoardIdentifier, bundle: nil).instantiateViewController(withIdentifier: Constants.CartViewControllerIdentifier) as! CartViewController
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Shopping Cart"
        
        self.setupTheme()
        self.setupNavigationBarItems()

        self.tableView.register(UINib(nibName: CartTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: CartTableViewCell.cellReuseID)
        
        do {
            try self.fetchedResultController.performFetch()
            if self.fetchedResultController.fetchedObjects?.count == 0 {
                AlertManager.showSingleButtonAlertView(from: self, title: "Shoppingcart is empty", message: "Please add products to your cart to be able to proceed")
            }
            self.tableView.reloadData()
        }
        catch let error {
            print(error)
        }
    }
    
    // ==========================================================================
    // MARK: - Private Methods
    // ==========================================================================
    
    fileprivate func setupTheme() {
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationBarColor()
        
        self.view.backgroundColor = UIColor.defaultViewBackgroundColor()
        self.tableView.backgroundColor = UIColor.clear
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    fileprivate func setupCheckoutHeaderView() -> UIView {
        
        let checkoutHeaderViewInstance = CheckoutHeaderView.newInstance()
        checkoutHeaderViewInstance.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: self.tableView.frame.width, height: self.isPad() ? CheckoutHeaderView.Constants.HeightiPad : CheckoutHeaderView.Constants.Height))
        
        checkoutHeaderViewInstance.updateHeaderView(with: self.calculateTotalCartValue(), currencyCode: self.cartCurrencyCode)

        checkoutHeaderViewInstance.delegate = self
        
        self.checkoutHeaderView = checkoutHeaderViewInstance
        
        return checkoutHeaderViewInstance
    }
    
    fileprivate func setupNavigationBarItems() {
        
        // Left
        let backButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(self.closeButtonPressed))
        backButton.tintColor = UIColor.defaultButtonTintColor()
        
        self.navigationItem.leftBarButtonItems = [backButton]
        
        self.setupCheckoutButton()
    }
    
    fileprivate func setupCheckoutButton() {
        // Right
        let modeButton = UIBarButtonItem(image: UIImage(named: "Checkout_Icon"), style: .plain, target: self, action: #selector(self.switchToModeCheckout))
        modeButton.tintColor = UIColor.defaultButtonTintColor()
        
        self.navigationItem.rightBarButtonItems = [modeButton]
    }
    
    @objc fileprivate func closeButtonPressed() {
        self.dismiss(animated: true)
    }
    
    @objc fileprivate func switchToModeCheckout() {
        self.mode = .checkout
    }
    
    fileprivate func calculateTotalCartValue() -> Double {
        var totalValue: Double = 0.0
        if let allItems = self.fetchedResultController.fetchedObjects as? [CartItem]{
            for cartItem in allItems {
                if let price = cartItem.product?.price {
                    totalValue += Double(Float(cartItem.amount) * price)
                }
            }
        }
        
        return totalValue
    }
    
    fileprivate func updateHeaderView() {
        self.checkoutHeaderView?.updateHeaderView(with: self.calculateTotalCartValue(), currencyCode: self.cartCurrencyCode)
    }
    
    fileprivate func finishPurchase() {
        
        // Remove delegate to ignore unwanted callbacks
        self.fetchedResultController.delegate = nil
        
        // Clear cart
        CartManager.clearCart()
        
        
        // Close ViewController
        self.closeButtonPressed()
    }
    
    func deviceOrientationDidChange(notification: NSNotification?) {
        
        var shouldHandleRotation = false
        
        switch UIDevice.current.orientation {
        case .landscapeLeft:
            fallthrough
        case .landscapeRight:
            shouldHandleRotation = true
            break
        case .portrait:
            fallthrough
        case .portraitUpsideDown:
            shouldHandleRotation = true
            break
        default:
            // ignore
            break
        }
        
        if shouldHandleRotation {
            UIView.animate(withDuration: 0.1, animations: {
                if self.mode == .checkout {
                    self.tableView.tableHeaderView = nil
                    self.tableView.tableHeaderView = self.setupCheckoutHeaderView()
                }
                self.tableView.reloadData()
            })
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        UIView.animate(withDuration: 0.1, animations: {
            if self.mode == .checkout {
                self.tableView.tableHeaderView = nil
                self.tableView.tableHeaderView = self.setupCheckoutHeaderView()
            }
            self.tableView.reloadData()
        })
    }
}

//==========================================================================
//MARK:- TableView DataSource
//==========================================================================

extension CartViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.cellReuseID, for: indexPath) as! CartTableViewCell
        
        if let cartItem = self.fetchedResultController.fetchedObjects?[indexPath.row] as? CartItem {
            cell.setupCell(with: cartItem, cartMode: self.mode)
            cell.delegate = self
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.mode {
        case .modify:
            return 121.0
        case .checkout:
            return 40.0
        }
    }
}

//==========================================================================
//MARK:- TableView Delegate
//==========================================================================

extension CartViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Nothing to do here
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// ==========================================================================
// MARK: - NSFetchedResultsControllerDelegate Methods
// ==========================================================================

extension CartViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .fade)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.reloadData()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.reloadData()
    }
}

//==========================================================================
//MARK:- CartTableViewCellDelegate
//==========================================================================

extension CartViewController : CartTableViewCellDelegate {
    
    func didPressIncreaseAmountButton(on cell: CartTableViewCell) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            if let cartItem = self.fetchedResultController.fetchedObjects?[indexPath.row] as? CartItem {
                cartItem.amount += 1
            }
        }
    }
    
    func didPressDecreaseAmountButton(on cell: CartTableViewCell) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            if let cartItem = self.fetchedResultController.fetchedObjects?[indexPath.row] as? CartItem {
                let newAmount = cartItem.amount - 1
                
                if newAmount == 0 {
                   self.showDeleteAlertForLastItem(lastItem: cartItem)
                }
                else {
                    cartItem.amount = newAmount
                    CoreDataStack.sharedInstance.saveContext()
                }
            }
        }
    }
    
    func showDeleteAlertForLastItem(lastItem: CartItem) {
        if let productTitle = lastItem.product?.title {
            AlertManager.showDoubleButtonAlertView(from: self, title: "Delete product?", message: "You are about to lower the amount of \(productTitle) to 0. This will remove this product from your shopping cart.", actionButtonAction: {
                CoreDataStack.sharedInstance.delete(cartItem: lastItem)
                CoreDataStack.sharedInstance.saveContext()
            })
        }
    }
}

//==========================================================================
//MARK:- CheckoutHeaderViewDelegate
//==========================================================================

extension CartViewController : CheckoutHeaderViewDelegate {
    func didPressCancelButton() {
        self.hidePickerView()
        self.mode = .modify
    }
    
    func didPressProceedButton() {
        
        AlertManager.showSingleButtonAlertView(from: self, title: "Thanks for shopping with us!", message: "We know where you live and the purchased amount has already been deducted from your credit card, don't worry! We got this ;)") {
            self.finishPurchase()
        }
    }
    
    func didPressChangeCurrencyButton() {
        self.presentCurrencyPicker()
    }
    
    func errorLoadingExchangeRates(error: Error) {
        AlertManager.showSingleButtonAlertView(from: self, title: "Error", message: "Could not load exchange values for different currencies. Please make sure you are connected to the Internet")
    }
}

//==========================================================================
//MARK:- CurrencyPickerViewController related Methods
//==========================================================================

extension CartViewController {
    
    fileprivate func presentCurrencyPicker(animated: Bool = true) {
        if self.currencyPickerViewController == nil {
            if let allCurrencies = CurrencyManager.sharedInstance.availableCurrencies {
                self.currencyPickerViewController = CurrencyPickerViewController.newInstance(with: allCurrencies, delegate: self)
            }
        }
        
        guard let picker = self.currencyPickerViewController else { return }
        
        if picker.view.superview == nil {
            picker.view.frame = self.pickerHiddenFrame()
            
            self.view.addSubview(picker.view)
            picker.preselect(currency: self.cartCurrencyCode)
        }
        
        picker.view.isHidden = false
        
        let animationDuration = animated ? 0.3 : 0
        UIView.animate(withDuration: animationDuration) {
            picker.view.frame = self.pickerPresentedFrame()
        }
    }
    
    fileprivate func hidePickerView(animated: Bool = true) {
        guard let picker = self.currencyPickerViewController else { return }
        
        let animationDuration = animated ? 0.3 : 0
        UIView.animate(withDuration: animationDuration, animations: {
            picker.view.frame = self.pickerHiddenFrame()
        }) { (finished) in
            if finished {
                picker.view.isHidden = true
                // Free resources
                self.currencyPickerViewController?.view.removeFromSuperview()
                self.currencyPickerViewController = nil
            }
        }
    }
    
    fileprivate func pickerPresentedFrame() -> CGRect {
        return CGRect(origin: CGPoint(x: 0, y: self.view.frame.size.height - CurrencyPickerViewController.Constants.Height), size: CGSize(width: self.view.frame.width, height: CurrencyPickerViewController.Constants.Height))
    }
    
    fileprivate func pickerHiddenFrame() -> CGRect {
        return CGRect(origin: CGPoint(x: 0, y: self.view.frame.size.height), size: CGSize(width: self.view.frame.width, height: CurrencyPickerViewController.Constants.Height))
    }
}

//==========================================================================
//MARK:- CurrencyPickerViewControllerDelegate
//==========================================================================

extension CartViewController : CurrencyPickerViewControllerDelegate {
    
    func didDidSelectCurrency(currency: String) {
        self.cartCurrencyCode = currency
        self.hidePickerView()
        
        self.updateHeaderView()
    }
}
