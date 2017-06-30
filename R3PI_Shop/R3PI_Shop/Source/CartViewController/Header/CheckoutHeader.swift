//
//  CheckoutHeader.swift
//  R3PI_Shop
//
//  Created by Anatoli Benke on 30/6/2017.
//  Copyright © 2017 Private. All rights reserved.
//

import UIKit

class CheckoutHeader: UIView {
    
    //==========================================================================
    //MARK:- Constants
    //==========================================================================
    
    struct Constants {
        static let NibName: String = "CheckoutHeader"
        static let Height: CGFloat = 140.0
        static let HeightiPad: CGFloat = 180.0
    }
    
    //==========================================================================
    //MARK:- Outlets
    //==========================================================================
    
    
    //==========================================================================
    //MARK:- New Instance
    //==========================================================================
    
    class func newInstance() -> CheckoutHeader {
        let controller = Bundle.main.loadNibNamed(Constants.NibName, owner: self, options: nil)?.first
        return controller as! CheckoutHeader
    }

    

}
