//
//  ShopCollectionViewCell.swift
//  R3PI_Shop
//
//  Created by Anatoli Benke on 22.06.17.
//  Copyright © 2017 Private. All rights reserved.
//

import UIKit

@objc protocol ShopCollectionViewCellDelegate: class {
    
    func didPressAddToCartButton(on cell: ShopCollectionViewCell, button: UIButton)
}

class ShopCollectionViewCell: UICollectionViewCell {
    
    //==========================================================================
    //MARK:- Constants
    //==========================================================================
    struct Constants {
        static let cellReuseID = "ShopCollectionViewCellReuseID"
        static let nibName     = "ShopCollectionViewCell"
    }
    
    class var cellReuseID : String { get { return Constants.cellReuseID } }
    class var nibName : String { get { return Constants.nibName } }
    
    //==========================================================================
    //MARK:- Outlets
    //==========================================================================
    
    @IBOutlet weak var imageView:       UIImageView!
    
    @IBOutlet fileprivate weak var titleLabel:      UILabel!
    @IBOutlet fileprivate weak var subTitleLabel:   UILabel!
    @IBOutlet fileprivate weak var priceLabel:      ShopLabel!
    
    @IBOutlet fileprivate weak var addToCartButton: UIButton!
    
    // ==========================================================================
    // MARK: - Properties
    // ==========================================================================
    
    weak var delegate: ShopCollectionViewCellDelegate?
    
    // ==========================================================================
    // MARK: - Cell Methods
    // ==========================================================================
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupTheme()
    }
    
    fileprivate func setupTheme() {
        
        ThemeManager.shopCollectionViewCellStyle(self)
        
        ThemeManager.shopCollectionViewCellImageViewStyle(self.imageView)
        
        ThemeManager.shopCollectionViewCellTitleLabelStyle(self.titleLabel)
        ThemeManager.shopCollectionViewCellSubTitleLabelStyle(self.subTitleLabel)
        ThemeManager.shopCollectionViewCellPriceLabelStyle(self.priceLabel)
        
        ThemeManager.shopCollectionViewCellAddToCartButtonStyle(self.addToCartButton)
    }
    
    func setupCell(with product: ShopProduct) {
        
        self.titleLabel.text = product.title
        self.subTitleLabel.text = product.desc
        
        if let price = CurrencyManager.sharedInstance.currencyString(with: Double(product.price), currencyCode: CurrencyManager.sharedInstance.sourceCurrency!) {
            self.priceLabel.text = "\(price)"
        }
        else {
            priceLabel.text = ""
        }
        
        if let imageURLString = product.imageURL {
            self.imageView.loadImageUsingCacheWithURLString(imageURLString, placeHolder: UIImage(named: "placeHolderImage"))
        }
    }
    
    // ==========================================================================
    // MARK: - IBActions
    // ==========================================================================
    
    @IBAction fileprivate func addToCartButtonPressed(sender: UIButton) {
        self.delegate?.didPressAddToCartButton(on: self, button: sender)
    }
}
