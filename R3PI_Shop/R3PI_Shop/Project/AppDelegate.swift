//
//  AppDelegate.swift
//  R3PI_Shop
//
//  Created by Anatoli Benke on 22.06.17.
//  Copyright © 2017 Private. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        CoreDataStack.sharedInstance.applicationDocumentsDirectory()
        
        return true
    }
}

