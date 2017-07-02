//
//  AlertManager.swift
//  R3PI_Shop
//
//  Created by Anatoli Benke on 1/7/2017.
//  Copyright © 2017 Private. All rights reserved.
//

import UIKit

class AlertManager {

    // ==========================================================================
    // MARK: - Shared Instance
    // ==========================================================================
    
    static let sharedInstance = AlertManager()
    
    // ==========================================================================
    // MARK: - Methods
    // ==========================================================================
    
    class func showSingleButtonAlertView(from viewController: UIViewController, title: String, message: String, actionButtonAction: (() -> Void)? = nil) {
        AlertManager.sharedInstance.showSingleButtonAlertView(from: viewController, title: title, message: message, actionButtonAction: actionButtonAction)
    }
    
    func showSingleButtonAlertView(from viewController: UIViewController, title: String, message: String, actionButtonAction: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction!) in
            actionButtonAction?()
        })
        viewController.present(alert, animated: true, completion: nil)
    }
}
