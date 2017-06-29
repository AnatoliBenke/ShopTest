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
    
    func cartTableViewCellStyle(_ cell: UICollectionViewCell)
    func cartTableViewCellTitleLabelStyle(_ label: UILabel)
    func cartTableViewCellSubTitleLabelStyle(_ label: UILabel)
    func cartTableViewCellImageViewStyle(_ imageView: UIImageView)
    
}
