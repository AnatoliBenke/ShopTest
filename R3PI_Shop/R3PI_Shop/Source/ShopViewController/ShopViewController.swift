//
//  ShopViewController.swift
//  R3PI_Shop
//
//  Created by Anatoli Benke on 22.06.17.
//  Copyright © 2017 Private. All rights reserved.
//

import UIKit
import CoreData

class ShopViewController: UIViewController {
    
    //==========================================================================
    //MARK:- Constants
    //==========================================================================
    
    struct Constants {
        static let CollectionViewLeftRightPaddingiPad           : CGFloat = 44.0
        static let CollectionViewTopPaddingiPad                 : CGFloat = 0.0
        static let CollectionViewBottomPaddingiPad              : CGFloat = 16.0
        
        static let CollectionViewLeftRightPaddingiPhone         : CGFloat = 16.0
        static let CollectionViewTopPaddingiPhone               : CGFloat = 0.0
        static let CollectionViewBottomPaddingiPhone            : CGFloat = 16.0
        
        static let CollectionViewRowPaddingiPad                 : CGFloat = 5.0
        static let CollectionViewColPaddingiPad                 : CGFloat = 5.0
        static let CollectionViewRowPaddingiPhone               : CGFloat = 30.0
        
        static let CollectionViewCellHeightMultiplier           : CGFloat = 0.8
        static let CollectionViewCellCountInRowiPadLandscape    : CGFloat = 3
        static let CollectionViewCellCountInRowiPadPortrait     : CGFloat = 2
    }
    
    //==========================================================================
    //MARK:- Variables
    //==========================================================================
    
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: ShopProduct.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()

    //==========================================================================
    //MARK:- Outlets
    //==========================================================================
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
    // ==========================================================================
    // MARK: - UIViewController Methods
    // ==========================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCollectionView()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.title = "R3PI Grossery Store"
        
        self.view.backgroundColor = UIColor.defaultViewBackgroundColor()
        self.collectionView.backgroundColor = UIColor.clear
        
        self.setupNavigationBarItems()
        
        
        AppConfigurationManager.sharedInstance.loadAppConfiguration { configResult in
            switch configResult {
                case .Success(_):
                    do {
                        try self.fetchedhResultController.performFetch()
                        self.collectionView.reloadData()
                    }
                    catch let error {
                        print(error)
                    }
                    
                    
                    CurrencyApiManager.sharedInstance.getCurrencyQuotes { result in
                        print("\(result)")
                        print("")
                    }
                    
                break
                
                case .Error(let error):
                    print(error)
            }
        }
        
        
        
        
         NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    // ==========================================================================
    // MARK: - Private Methods
    // ==========================================================================
    var cartButton: BadgeButtonItem?
    
    fileprivate func setupNavigationBarItems() {
        self.cartButton = BadgeButtonItem(image: UIImage(named: "CartIcon"), style: .plain, target: self, action: #selector(self.presentCartViewController))
        self.cartButton!.setupBadgeView()
        
        
        self.navigationItem.rightBarButtonItems = [self.cartButton!]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.cartButton!.badgeValue = 10
    }
    
    @objc fileprivate func presentCartViewController() {
        let cartVC = CartViewController.newInstance()
        
        let navigationController = UINavigationController(rootViewController: cartVC)
        if self.isPad() {
            let width = self.view.frame.width * CartViewController.Constants.TabletViewWidthMultiplier
            let height = self.view.frame.height * CartViewController.Constants.TabletViewHeightMultiplier
            navigationController.preferredContentSize = CGSize(width: width, height: height)
            navigationController.modalPresentationStyle = .formSheet
        }
        
        self.navigationController?.present(navigationController, animated: true)
    }
    
    fileprivate func setupCollectionView() {
        // Register collectionViewCell
        collectionView!.register(UINib(nibName: ShopCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: ShopCollectionViewCell.cellReuseID)
    }
    
    // ==========================================================================
    // MARK: - Orientation Methods
    // ==========================================================================
    
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
                self.collectionView.collectionViewLayout.invalidateLayout()
            }) { (finished) in
                if finished {
                    self.collectionView.isHidden = false
                }
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self.collectionView.isHidden = true
        
        coordinator.animate(alongsideTransition: nil, completion: { _ in
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.isHidden = false
        })
    }
    
    // ==========================================================================
    // MARK: - Deal with MultiTasking
    // ==========================================================================
    
    fileprivate func getCellCountInRow() -> CGFloat {
        if self.isPad() && UIDevice.current.orientation.isLandscape {
            if self.view.frame.width <= (UIScreen.main.bounds.width * 0.5) {
                return 1
            }
            else if self.view.frame.width < UIScreen.main.bounds.width {
                return Constants.CollectionViewCellCountInRowiPadLandscape - 1
            }
            
            return Constants.CollectionViewCellCountInRowiPadLandscape
        }
        else if self.isPad() {
            if self.view.frame.width < UIScreen.main.bounds.width {
                return 1
            }
            return Constants.CollectionViewCellCountInRowiPadPortrait
        }
        else {
            return 1
        }
    }
}

// ==========================================================================
// MARK: - UICollectionViewDataSource Methods
// ==========================================================================

extension ShopViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.fetchedhResultController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopCollectionViewCell.cellReuseID, for: indexPath as IndexPath) as! ShopCollectionViewCell
        
        if let product = self.fetchedhResultController.fetchedObjects?[indexPath.row] as? ShopProduct {
            cell.setupCell(with: product)
            cell.delegate = self
        }
        
        return cell
    }
    
    @objc(collectionView:layout:sizeForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if self.isPad() {
            let numberOfRows = self.getCellCountInRow()
            
            let width = (self.view.frame.size.width - (2 * Constants.CollectionViewLeftRightPaddingiPad) - ((numberOfRows - 1) * Constants.CollectionViewColPaddingiPad)) / numberOfRows
            let height = width * Constants.CollectionViewCellHeightMultiplier
            
            return CGSize(width: width, height: height)
        }
        else {
            let width = self.view.frame.size.width - (2 * Constants.CollectionViewLeftRightPaddingiPhone)
            let height = width * Constants.CollectionViewCellHeightMultiplier
            
            return CGSize(width: width, height: height)
        }
    }
    
    @objc(collectionView:layout:insetForSectionAtIndex:) func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if self.isPad() {
            return UIEdgeInsetsMake(Constants.CollectionViewLeftRightPaddingiPad,
                                    Constants.CollectionViewLeftRightPaddingiPad,
                                    Constants.CollectionViewBottomPaddingiPad,
                                    Constants.CollectionViewLeftRightPaddingiPad)
        }
        else {
            return UIEdgeInsetsMake(Constants.CollectionViewLeftRightPaddingiPhone,
                                    Constants.CollectionViewLeftRightPaddingiPhone,
                                    Constants.CollectionViewBottomPaddingiPhone,
                                    Constants.CollectionViewLeftRightPaddingiPhone)
        }
    }
    
    @objc(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:) func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if self.isPad() {
            return Constants.CollectionViewColPaddingiPad
        }
        else {
            return 0
        }
    }
    
    @objc(collectionView:layout:minimumLineSpacingForSectionAtIndex:) func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if self.isPad() {
            return Constants.CollectionViewRowPaddingiPad
        }
        else {
            return Constants.CollectionViewRowPaddingiPhone
        }
    }
    
}

// ==========================================================================
// MARK: - NSFetchedResultsControllerDelegate Methods
// ==========================================================================

extension ShopViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.collectionView.insertItems(at: [newIndexPath!])
        case .delete:
            self.collectionView.deleteItems(at: [indexPath!])
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.collectionView.reloadData()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.collectionView.reloadData()
    }
}

// ==========================================================================
// MARK: - UICollectionViewDelegate Methods
// ==========================================================================

extension ShopViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Open product detail page
    }
}

// ==========================================================================
// MARK: - ShopCollectionViewCellDelegate Methods
// ==========================================================================

extension ShopViewController: ShopCollectionViewCellDelegate {
    
    func didPressAddToCartButton(on cell: ShopCollectionViewCell, button: UIButton) {
        if let indexPath = self.collectionView.indexPath(for: cell) {
            if let product = self.fetchedhResultController.fetchedObjects?[indexPath.row] as? ShopProduct {
                CartManager.sharedInstance.add(product: product)
            }
        }
    }
}

