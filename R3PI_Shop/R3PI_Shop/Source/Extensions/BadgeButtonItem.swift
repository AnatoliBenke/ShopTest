//
//  BadgeButtonItem.swift
//  R3PI_Shop
//
//  Created by Anatoli Benke on 28.06.17.
//  Copyright © 2017 Private. All rights reserved.
//

import UIKit

class BadgeButtonItem: UIBarButtonItem {
    
    var badgeLabel: UILabel?
    var badgeValue: Int = 0 {
        didSet {
            guard let badge = self.badgeLabel else {
                return
            }
            badge.text = "\(self.badgeValue)"
            badge.isHidden = false
        }
    }
    
    func setupBadgeView() {
        if self.badgeLabel == nil {
            self.badgeLabel = UILabel(frame: CGRect(x: 10, y: -10, width: 20, height: 20))
            self.badgeLabel?.layer.borderColor = UIColor.clear.cgColor
            self.badgeLabel?.layer.borderWidth = 2
            self.badgeLabel?.layer.cornerRadius = self.badgeLabel!.bounds.size.height / 2
            self.badgeLabel?.textAlignment = .center
            self.badgeLabel?.layer.masksToBounds = true
            self.badgeLabel?.font = UIFont(name: "SanFranciscoText-Light", size: 13)
            self.badgeLabel?.textColor = .white
            self.badgeLabel?.backgroundColor = .red
            self.badgeLabel?.isHidden = true
        }
    }
}
