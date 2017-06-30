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
    
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: CartItem.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "product.title", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    var mode: CartMode = .modify
    
    var checkoutHeaderView: CheckoutHeader?
    
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
        
        self.setupNavigationBarItems()
        
        self.automaticallyAdjustsScrollViewInsets = false

        self.tableView.register(UINib(nibName: CartTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: CartTableViewCell.cellReuseID)
        
        do {
            try self.fetchedhResultController.performFetch()
            self.tableView.reloadData()
        }
        catch let error {
            print(error)
        }
        
        
        //self.setupCheckoutHeaderView()
    }
    
    fileprivate func setupCheckoutHeaderView() {
        self.checkoutHeaderView = CheckoutHeader.newInstance()
        self.checkoutHeaderView?.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: self.tableView.frame.width, height: self.isPad() ? CheckoutHeader.Constants.HeightiPad : CheckoutHeader.Constants.Height))
        self.tableView.tableHeaderView = self.checkoutHeaderView
    }
    
    fileprivate func setupNavigationBarItems() {
        let backButton = UIBarButtonItem(image: UIImage(named: "CartIcon"), style: .plain, target: self, action: #selector(self.closeButtonPressed))
        
        self.navigationItem.leftBarButtonItems = [backButton]
        
        
        let modeButton1 = UIBarButtonItem(image: UIImage(named: "CartIcon"), style: .plain, target: self, action: #selector(self.switchToModeCheckout))
        
        let modeButton2 = UIBarButtonItem(image: UIImage(named: "CartIcon"), style: .plain, target: self, action: #selector(self.switchToModeModify))
        
        self.navigationItem.rightBarButtonItems = [modeButton1, modeButton2]
    }
    
    @objc fileprivate func closeButtonPressed() {
        self.dismiss(animated: true)
    }
    
    @objc fileprivate func switchToModeModify() {
        self.mode = .modify
        self.tableView.reloadData()
    }
    
    @objc fileprivate func switchToModeCheckout() {
        self.mode = .checkout
        self.tableView.reloadData()
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
        return self.fetchedhResultController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.cellReuseID, for: indexPath) as! CartTableViewCell
        
        if let cartItem = self.fetchedhResultController.fetchedObjects?[indexPath.row] as? CartItem {
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
            if let cartItem = self.fetchedhResultController.fetchedObjects?[indexPath.row] as? CartItem {
                cartItem.amount += 1
            }
        }
    }
    
    func didPressDecreaseAmountButton(on cell: CartTableViewCell) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            if let cartItem = self.fetchedhResultController.fetchedObjects?[indexPath.row] as? CartItem {
                cartItem.amount -= 1
                
                if cartItem.amount == 0 {
                    CoreDataStack.sharedInstance.delete(cartItem: cartItem)
                }
            }
        }
    }
    
}

