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
    
    class func cartTableViewCellStyle(_ cell: UITableViewCell) {
        self.sharedInstance.theme.cartTableViewCellStyle(cell)
    }
    
    class func cartTableViewCellTitleLabelStyle(_ label: UILabel) {
        self.sharedInstance.theme.cartTableViewCellTitleLabelStyle(label)
    }
    
    class func cartTableViewCellSubTitleLabelStyle(_ label: UILabel) {
        self.sharedInstance.theme.cartTableViewCellSubTitleLabelStyle(label)
    }
    
    class func cartTableViewCellPriceTotalLabelStyle(_ label: UILabel) {
        self.sharedInstance.theme.cartTableViewCellPriceTotalLabelStyle(label)
    }
    
    class func cartTableViewCellPriceLabelStyle(_ label: UILabel) {
        self.sharedInstance.theme.cartTableViewCellPriceLabelStyle(label)
    }
    
    class func cartTableViewCellImageViewStyle(_ imageView: UIImageView) {
        self.sharedInstance.theme.cartTableViewCellImageViewStyle(imageView)
    }
    
    
    class func cartTableViewPriceDeviderImageViewStyle(_ imageView: UIImageView) {
        self.sharedInstance.theme.cartTableViewPriceDeviderImageViewStyle(imageView)
    }
    
    class func cartTableViewCellCellDeviderImageViewStyle(_ imageView: UIImageView) {
        self.sharedInstance.theme.cartTableViewCellCellDeviderImageViewStyle(imageView)
    }
    
    class func cartTableViewCellDecreaseButtonStyle(_ button: UIButton) {
        self.sharedInstance.theme.cartTableViewCellDecreaseButtonStyle(button)
    }
    
    class func cartTableViewCellIncreaseButtonStyle(_ button: UIButton) {
        self.sharedInstance.theme.cartTableViewCellIncreaseButtonStyle(button)
    }
    
    // ==========================================================================
    // MARK: - CheckoutHeaderView
    // ==========================================================================
    
    class func checkoutHeaderViewStyle(_ view: UIView) {
        self.sharedInstance.theme.checkoutHeaderViewStyle(view)
    }
    
    class func checkoutHeaderViewPrefixLabelStyle(_ label: UILabel) {
        self.sharedInstance.theme.checkoutHeaderViewPrefixLabelStyle(label)
    }
    
    class func checkoutHeaderViewPriceLabelStyle(_ label: UILabel) {
        self.sharedInstance.theme.checkoutHeaderViewPriceLabelStyle(label)
    }
    
    class func checkoutHeaderViewChangeCurrencyButtonStyle(_ button: UIButton) {
        self.sharedInstance.theme.checkoutHeaderViewChangeCurrencyButtonStyle(button)
    }
    
    class func checkoutHeaderViewCancelButtonStyle(_ button: UIButton) {
        self.sharedInstance.theme.checkoutHeaderViewCancelButtonStyle(button)
    }
    
    class func checkoutHeaderViewProceedButtonStyle(_ button: UIButton) {
        self.sharedInstance.theme.checkoutHeaderViewProceedButtonStyle(button)
    }
}
