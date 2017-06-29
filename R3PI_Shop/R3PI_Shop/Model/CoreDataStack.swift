//
//  CoreDataStack.swift
//  R3PI_Shop
//
//  Created by Anatoli Benke on 25.06.17.
//  Copyright © 2017 Private. All rights reserved.
//


import Foundation
import UIKit
import CoreData

class CoreDataStack: NSObject {
    
    // ==========================================================================
    // MARK: - shared Instance
    // ==========================================================================
    
    static let sharedInstance = CoreDataStack()
    
    // ==========================================================================
    // MARK: - applicationDocumentsDirectory
    // ==========================================================================
    
    private override init() {}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "R3PI_Shop")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchRecordsForEntity(_ entity: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> [NSManagedObject] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        var result = [NSManagedObject]()
        
        do {
            let records = try managedObjectContext.fetch(fetchRequest)
            
            if let records = records as? [NSManagedObject] {
                result = records
            }
        }
        catch {
            print("Unable to fetch managed objects for entity \(entity).")
        }
        
        return result
    }
}

// ==========================================================================
// MARK: - applicationDocumentsDirectory
// ==========================================================================

extension CoreDataStack {
    
    func applicationDocumentsDirectory() {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "yo.BlogReaderApp" in the application's documents directory.
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            print(url.absoluteString)
        }
    }
}

// ==========================================================================
// MARK: - Product Methods
// ==========================================================================

extension CoreDataStack {
    
    fileprivate struct ProductParseKeys {
        static let Title        = "title"
        static let Desc         = "description"
        static let DetailedDesc = "detailedDescription"
        static let ImageURL     = "imageURL"
        static let Price        = "price"
        static let ProductId    = "productId"
    }
    
    func createProductEntityFrom(dictionary: [String: Any]) -> NSManagedObject? {
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let aProduct = NSEntityDescription.insertNewObject(forEntityName: String(describing: ShopProduct.self), into: context) as? ShopProduct {
            
            self.update(product: aProduct, dictionary: dictionary)
            
            return aProduct
        }
        
        return nil
    }
    
    fileprivate func update(product: ShopProduct, dictionary: [String: Any]) {
        
        product.title = dictionary[ProductParseKeys.Title] as? String
        product.desc = dictionary[ProductParseKeys.Desc] as? String
        product.detailedDesc = dictionary[ProductParseKeys.DetailedDesc] as? String
        product.imageURL = dictionary[ProductParseKeys.ImageURL] as? String
        product.price = Float(dictionary[ProductParseKeys.Price] as? Double ?? 0.0)
        product.productId = dictionary[ProductParseKeys.ProductId] as? Int64 ?? 0
        
        product.updatedDate = NSDate()
        
        self.saveContext()
    }
    
    func getProduct(for Id: Int64) -> ShopProduct? {
        let context = self.persistentContainer.viewContext
        let fetchRequest = ShopProduct.request
        let predicate = NSPredicate(format: "productId == %d", Id)
        fetchRequest.predicate = predicate
        
        do {
            let objects = try context.fetch(fetchRequest)
            return objects.first
        }
        catch let error {
            print("ERROR Fetching : \(error)")
        }
        
        return nil
    }
    
    func createUpdateOrDeleteProducts(with array: [[String: Any]]) {
        
        var productsToCreate = [[String: Any]]()
        let updateStartDate = NSDate()
        
        for rawProduct in array {
            if let id = rawProduct[ProductParseKeys.ProductId] as? Int {
                if let existingProduct = self.getProduct(for: Int64(id)) {
                    self.update(product: existingProduct, dictionary: rawProduct)
                }
                else {
                    productsToCreate.append(rawProduct)
                }
            }
        }
        
        self.saveProductsInCoreDataWith(array: productsToCreate)
        self.deleteProducts(before: updateStartDate)
        
        self.saveContext()
    }
    
    fileprivate func deleteProducts(before date: NSDate) {
        let context = self.persistentContainer.viewContext
        let fetchRequest = ShopProduct.request
        let predicate = NSPredicate(format: "updatedDate < %@", date)
        fetchRequest.predicate = predicate
        
        do {
            let objects = try context.fetch(fetchRequest)
            
            for outdatedProduct in objects {
                if let cartItem = self.getCartItem(for: outdatedProduct) {
                    self.delete(cartItem: cartItem)
                }
                self.delete(shopProduct: outdatedProduct)
            }
        }
        catch let error {
            print("ERROR Fetching : \(error)")
        }
    }
    
    func delete(shopProduct: ShopProduct) {
        let context = self.persistentContainer.viewContext
        context.delete(shopProduct)
        self.saveContext()
    }
    
    func saveProductsInCoreDataWith(array: [[String: Any]]) {
        _ = array.map{ self.createProductEntityFrom(dictionary: $0) }
        self.saveContext()
    }
    
    func clearProductData() {
        do {
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: ShopProduct.self))
            do {
                let objects = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                self.saveContext()
            }
            catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
}

// ==========================================================================
// MARK: - CartItem Methods
// ==========================================================================

extension CoreDataStack {
    
    func createCartItemEntity(product: ShopProduct) -> NSManagedObject? {
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let aCartItem = NSEntityDescription.insertNewObject(forEntityName: String(describing: CartItem.self), into: context) as? CartItem {
            
            aCartItem.product = product
            aCartItem.amount = 1
            
            return aCartItem
        }
        
        return nil
    }
    
    func getCartItem(for product: ShopProduct) -> CartItem? {
        let context = self.persistentContainer.viewContext
        let fetchRequest = CartItem.request
        let predicate = NSPredicate(format: "product.productId == %d", product.productId)
        fetchRequest.predicate = predicate
        
        do {
            let objects = try context.fetch(fetchRequest)
            return objects.first
        }
        catch let error {
            print("ERROR Fetching : \(error)")
        }
        
        return nil
    }
    
    func getAllSavedCartItems() -> [CartItem]? {
        let context = self.persistentContainer.viewContext
        let fetchRequest = CartItem.request
        
        do {
            let objects = try context.fetch(fetchRequest)
            return objects
        }
        catch let error {
            print("ERROR Fetching : \(error)")
        }
        
        return nil
    }
    
    func delete(cartItem: CartItem) {
        let context = self.persistentContainer.viewContext
        context.delete(cartItem)
        self.saveContext()
    }
    
    func clearCartItemData() {
        do {
            let context = self.persistentContainer.viewContext
            let fetchRequest = CartItem.request
            do {
                let objects = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                self.saveContext()
            }
            catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
}
