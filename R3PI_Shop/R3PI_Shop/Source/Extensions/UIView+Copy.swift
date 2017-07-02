//
//  UIView+Copy.swift
//  R3PI_Shop
//
//  Created by Anatoli Benke on 2/7/2017.
//  Copyright © 2017 Private. All rights reserved.
//

import UIKit

extension UIView {
    
    func copyView() -> Any {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self))! as Any
    }
}
