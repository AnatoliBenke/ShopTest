//
//  ThemeDefault.swift
//  R3PI_Shop
//
//  Created by Anatoli Benke on 24.06.17.
//  Copyright © 2017 Private. All rights reserved.
//

import UIKit

class ThemeIPadDefault: Theme {
    
    // ==========================================================================
    // MARK: - ShopCollectionViewCell
    // ==========================================================================
    
    func shopCollectionViewCellStyle(_ cell: UICollectionViewCell) {
        cell.backgroundColor = UIColor.cellBackgroundColor()
    }
    
    func shopCollectionViewCellTitleLabelStyle(_ label: UILabel) {
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.darkText
        
        label.backgroundColor = UIColor.clear
    }
    
    func shopCollectionViewCellSubTitleLabelStyle(_ label: UILabel) {
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightLight)
        label.textColor = UIColor.black
        
        label.backgroundColor = UIColor.clear
    }
    
    func shopCollectionViewCellPriceLabelStyle(_ label: ShopLabel) {
        label.font = UIFont.systemFont(ofSize: 17.0)
        
        label.layer.cornerRadius = label.frame.size.height / 2
        label.layer.masksToBounds = true
        
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.red
        
        label.edgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)
    }
    
    func shopCollectionViewCellImageViewStyle(_ imageView: UIImageView) {
        imageView.backgroundColor = UIColor.white
        imageView.contentMode = .scaleAspectFit
    }
    
    func shopCollectionViewCellAddToCartButtonStyle(_ button: UIButton) {
        button.setTitle("", for: .normal)
        button.backgroundColor = UIColor.clear
        button.tintColor = UIColor.defaultCtaColor()
        button.setImage(UIImage(named: "ToCartIcon"), for: .normal)
    }
    
    // ==========================================================================
    // MARK: - CartTableViewCell
    // ==========================================================================
    
    func cartTableViewCellStyle(_ cell: UITableViewCell) {
        cell.backgroundColor = UIColor.cellBackgroundColor()
        cell.contentView.backgroundColor = UIColor.cellBackgroundColor()
    }
    
    func cartTableViewCellTitleLabelStyle(_ label: UILabel) {
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.darkText
        
        label.backgroundColor = UIColor.clear
    }
    
    func cartTableViewCellSubTitleLabelStyle(_ label: UILabel) {
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightLight)
        label.textColor = UIColor.gray
        
        label.backgroundColor = UIColor.clear
    }
    
    func cartTableViewCellImageViewStyle(_ imageView: UIImageView) {
        imageView.backgroundColor = UIColor.white
        imageView.contentMode = .scaleAspectFit
    }
    
    func cartTableViewPriceDeviderImageViewStyle(_ imageView: UIImageView) {
        imageView.backgroundColor = UIColor.lightGray
    }
    
    func cartTableViewCellCellDeviderImageViewStyle(_ imageView: UIImageView) {
        imageView.backgroundColor = UIColor.red
    }
    
    func cartTableViewCellPriceTotalLabelStyle(_ label: UILabel) {
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightLight)
        label.textColor = UIColor.gray
        
        label.backgroundColor = UIColor.clear
    }
    
    func cartTableViewCellPriceLabelStyle(_ label: UILabel) {
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightLight)
        label.textColor = UIColor.gray
        
        label.backgroundColor = UIColor.clear
    }
    
    func cartTableViewCellDecreaseButtonStyle(_ button: UIButton) {
        button.setTitle("-", for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.defaultCtaColor(), for: .normal)
        
        button.layer.borderColor = UIColor.defaultCtaColor().cgColor
        button.layer.borderWidth = 1.0
        
        button.tintColor = UIColor.defaultCtaColor()
    }
    
    func cartTableViewCellIncreaseButtonStyle(_ button: UIButton) {
        button.setTitle("+", for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.defaultCtaColor(), for: .normal)
        
        button.layer.borderColor = UIColor.defaultCtaColor().cgColor
        button.layer.borderWidth = 1.0
        
        button.tintColor = UIColor.defaultCtaColor()
    }
    
    // ==========================================================================
    // MARK: - CheckoutHeaderView
    // ==========================================================================
    
    func checkoutHeaderViewStyle(_ view: UIView) {
        view.backgroundColor = UIColor.white
    }
    
    func checkoutHeaderViewPrefixLabelStyle(_ label: UILabel) {
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightRegular)
        label.textColor = UIColor.black
        
        label.backgroundColor = UIColor.clear
    }
    
    func checkoutHeaderViewPriceLabelStyle(_ label: UILabel) {
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightBold)
        label.textColor = UIColor.black
        
        label.backgroundColor = UIColor.clear
    }
    
    func checkoutHeaderViewChangeCurrencyButtonStyle(_ button: UIButton) {
        button.setTitle("Change Currency", for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.defaultCtaColor(), for: .normal)
        
        button.layer.borderColor = UIColor.defaultCtaColor().cgColor
        button.layer.borderWidth = 1.0
        
        button.tintColor = UIColor.defaultCtaColor()
    }
    
    func checkoutHeaderViewCancelButtonStyle(_ button: UIButton) {
        button.setTitle("X", for: .normal)
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.gray, for: .normal)
        
        button.tintColor = UIColor.black
    }
    
    func checkoutHeaderViewProceedButtonStyle(_ button: UIButton) {
        button.setTitle("Proceed", for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.defaultCtaColor(), for: .normal)
        
        button.layer.borderColor = UIColor.defaultCtaColor().cgColor
        button.layer.borderWidth = 1.0
        
        button.tintColor = UIColor.defaultCtaColor()
    }
}
