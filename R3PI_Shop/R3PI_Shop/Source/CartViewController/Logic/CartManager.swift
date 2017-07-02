//
//  CartManager.swift
//  R3PI_Shop
//
//  Created by Anatoli Benke on 27/6/2017.
//  Copyright © 2017 Private. All rights reserved.
//

import UIKit
import CoreData

class CartManager: NSObject {

    // ==========================================================================
    // MARK: - Shared Instance
    // ==========================================================================
    
    static let sharedInstance = CartManager()
    
    // ==========================================================================
    // MARK: - Variables
    // ==========================================================================
    
    var badgebutton: UIBarButtonItem?
    
    // ==========================================================================
    // MARK: - Managing Methods
    // ==========================================================================
    
    func add(product: ShopProduct) {
        if let existingCartItemForProduct = CoreDataStack.sharedInstance.getCartItem(for: product) {
            existingCartItemForProduct.amount += 1
        }
        else {
            _ = CoreDataStack.sharedInstance.createCartItemEntity(product: product)
        }
        CoreDataStack.sharedInstance.saveContext()
    }
    
    func remove(product: ShopProduct) {
        if let existingCartItemForProduct = CoreDataStack.sharedInstance.getCartItem(for: product) {
            existingCartItemForProduct.amount -= 1
            
            if existingCartItemForProduct.amount == 0 {
                self.remove(cartItem: existingCartItemForProduct)
            }
        }
    }
    
    func clearCart() {
        CoreDataStack.sharedInstance.clearCartItemData()
    }
    
    func remove(cartItem: CartItem) {
        CoreDataStack.sharedInstance.delete(cartItem: cartItem)
        CoreDataStack.sharedInstance.saveContext()
    }
}
