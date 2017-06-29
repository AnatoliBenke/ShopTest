//
//  UIResponder+IsPad.swift
//  R3PI_Shop
//
//  Created by Anatoli Benke on 22.06.17.
//  Copyright © 2017 Private. All rights reserved.
//

import UIKit

extension UIResponder {
    func isPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
