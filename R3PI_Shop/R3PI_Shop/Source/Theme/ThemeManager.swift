//
//  ThemeManager.swift
//  R3PI_Shop
//
//  Created by Anatoli Benke on 24.06.17.
//  Copyright © 2017 Private. All rights reserved.
//

import UIKit

enum ThemeType {
    case `default`
}

class ThemeManager {
    
    static let sharedInstance = ThemeManager()
    
    fileprivate var theme: Theme
    
    init() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.theme = ThemeIPadDefault()
        }
        else if UIDevice.current.isCompactiPhone {
            self.theme = UIDevice.current.isInDisplayZoomMode ? ThemeMediumPhone() : ThemeCompactPhone()
        }
        else if UIDevice.current.isMidSizeiPhone {
            self.theme = UIDevice.current.isInDisplayZoomMode ? ThemeDefault() : ThemeMediumPhone()
        }
        else if UIDevice.current.isLargeiPhone {
            self.theme = UIDevice.current.isInDisplayZoomMode ? ThemeMediumPhone() : ThemeLargePhone()
        }
        else {
            self.theme = ThemeDefault()
        }
    }
    
    func setTheme(_ type: ThemeType) {
        switch(type) {
        default:
            self.theme = ThemeDefault()
        }
    }
    
    // ==========================================================================
    // MARK: - ShopCollectionViewCell
    // ==========================================================================
    
    class func shopCollectionViewCellStyle(_ cell: UICollectionViewCell) {
        self.sharedInstance.theme.shopCollectionViewCellStyle(cell)
    }
    
    class func shopCollectionViewCellTitleLabelStyle(_ label: UILabel) {
        self.sharedInstance.theme.shopCollectionViewCellTitleLabelStyle(label)
    }
    
    class func shopCollectionViewCellSubTitleLabelStyle(_ label: UILabel) {
        self.sharedInstance.theme.shopCollectionViewCellSubTitleLabelStyle(label)
    }
    
    class func shopCollectionViewCellPriceLabelStyle(_ label: ShopLabel) {
        self.sharedInstance.theme.shopCollectionViewCellPriceLabelStyle(label)
    }
    
    
    class func shopCollectionViewCellImageViewStyle(_ imageView: UIImageView) {
        self.sharedInstance.theme.shopCollectionViewCellImageViewStyle(imageView)
    }
    
    class func shopCollectionViewCellAddToCartButtonStyle(_ button: UIButton) {
        self.sharedInstance.theme.shopCollectionViewCellAddToCartButtonStyle(button)
    }
    
    
    // ==========================================================================
    // MARK: - CartTableViewCell
    // ==========================================================================
    
    class func cartTableViewCellStyle(_ cell: UICollectionViewCell) {
        self.sharedInstance.theme.cartTableViewCellStyle(cell)
    }
    
    class func cartTableViewCellTitleLabelStyle(_ label: UILabel) {
        self.sharedInstance.theme.cartTableViewCellTitleLabelStyle(label)
    }
    
    class func cartTableViewCellSubTitleLabelStyle(_ label: UILabel) {
        self.sharedInstance.theme.cartTableViewCellSubTitleLabelStyle(label)
    }
    
    class func cartTableViewCellImageViewStyle(_ imageView: UIImageView) {
        self.sharedInstance.theme.cartTableViewCellImageViewStyle(imageView)
    }
    
    
}
