//
//  Theme.swift
//  R3PI_Shop
//
//  Created by Anatoli Benke on 24.06.17.
//  Copyright © 2017 Private. All rights reserved.
//

import UIKit

protocol Theme {
    
    // ==========================================================================
    // MARK: - ShopCollectionViewCell
    // ==========================================================================
    
    func shopCollectionViewCellStyle(_ cell: UICollectionViewCell)
    func shopCollectionViewCellTitleLabelStyle(_ label: UILabel)
    func shopCollectionViewCellSubTitleLabelStyle(_ label: UILabel)
    func shopCollectionViewCellPriceLabelStyle(_ label: ShopLabel)
    
    func shopCollectionViewCellImageViewStyle(_ imageView: UIImageView)
    func shopCollectionViewCellAddToCartButtonStyle(_ button: UIButton)
    
    // ==========================================================================
    // MARK: - CartTableViewCell
    // ==========================================================================
    
    func cartTableViewCellStyle(_ cell: UITableViewCell)
    func cartTableViewCellTitleLabelStyle(_ label: UILabel)
    func cartTableViewCellSubTitleLabelStyle(_ label: UILabel)
    func cartTableViewCellPriceTotalLabelStyle(_ label: UILabel)
    func cartTableViewCellPriceLabelStyle(_ label: UILabel)
    
    func cartTableViewCellImageViewStyle(_ imageView: UIImageView)
    func cartTableViewPriceDeviderImageViewStyle(_ imageView: UIImageView)
    func cartTableViewCellCellDeviderImageViewStyle(_ imageView: UIImageView)
    
    func cartTableViewCellDecreaseButtonStyle(_ button: UIButton)
    func cartTableViewCellIncreaseButtonStyle(_ button: UIButton)
    
    // ==========================================================================
    // MARK: - CheckoutHeaderView
    // ==========================================================================
    
    func checkoutHeaderViewStyle(_ view: UIView)
    func checkoutHeaderViewPrefixLabelStyle(_ label: UILabel)
    func checkoutHeaderViewPriceLabelStyle(_ label: UILabel)
    func checkoutHeaderViewChangeCurrencyButtonStyle(_ button: UIButton)
    func checkoutHeaderViewCancelButtonStyle(_ button: UIButton)
    func checkoutHeaderViewProceedButtonStyle(_ button: UIButton)
    
}
