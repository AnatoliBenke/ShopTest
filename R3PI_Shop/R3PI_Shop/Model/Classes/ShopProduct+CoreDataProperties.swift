//
//  ShopProduct+CoreDataProperties.swift
//  R3PI_Shop
//
//  Created by Anatoli Benke on 24.06.17.
//  Copyright © 2017 Private. All rights reserved.
//

import Foundation
import CoreData


extension ShopProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShopProduct> {
        return NSFetchRequest<ShopProduct>(entityName: "ShopProduct")
    }
    
    static let request: NSFetchRequest<ShopProduct> = ShopProduct.fetchRequest()

    @NSManaged public var desc: String?
    @NSManaged public var detailedDesc: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var price: Float
    @NSManaged public var productId: Int64
    @NSManaged public var title: String?
    @NSManaged public var updatedDate: NSDate?
    @NSManaged public var cart: NSSet?

}

// MARK: Generated accessors for cart
extension ShopProduct {

    @objc(addCartObject:)
    @NSManaged public func addToCart(_ value: CartItem)

    @objc(removeCartObject:)
    @NSManaged public func removeFromCart(_ value: CartItem)

    @objc(addCart:)
    @NSManaged public func addToCart(_ values: NSSet)

    @objc(removeCart:)
    @NSManaged public func removeFromCart(_ values: NSSet)

}
