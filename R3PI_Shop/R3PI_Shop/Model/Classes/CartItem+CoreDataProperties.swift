//
//  CartItem+CoreDataProperties.swift
//  R3PI_Shop
//
//  Created by Anatoli Benke on 24.06.17.
//  Copyright © 2017 Private. All rights reserved.
//

import Foundation
import CoreData


extension CartItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartItem> {
        return NSFetchRequest<CartItem>(entityName: "CartItem")
    }

    static let request: NSFetchRequest<CartItem> = CartItem.fetchRequest()
    
    @NSManaged public var amount: Int32
    @NSManaged public var product: ShopProduct?

}
