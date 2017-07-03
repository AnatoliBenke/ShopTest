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
    // MARK: - Managing Methods
    // ==========================================================================
    
    class func add(product: ShopProduct) {
        if let existingCartItemForProduct = CoreDataStack.sharedInstance.getCartItem(for: product) {
            existingCartItemForProduct.amount += 1
        }
        else {
            _ = CoreDataStack.sharedInstance.createCartItemEntity(product: product)
        }
        CoreDataStack.sharedInstance.saveContext()
    }
    
    class func remove(product: ShopProduct) {
        if let existingCartItemForProduct = CoreDataStack.sharedInstance.getCartItem(for: product) {
            existingCartItemForProduct.amount -= 1
            
            if existingCartItemForProduct.amount == 0 {
                self.remove(cartItem: existingCartItemForProduct)
            }
        }
    }
    
    class func clearCart() {
        CoreDataStack.sharedInstance.clearCartItemData()
    }
    
    class func remove(cartItem: CartItem) {
        CoreDataStack.sharedInstance.delete(cartItem: cartItem)
        CoreDataStack.sharedInstance.saveContext()
    }
}
