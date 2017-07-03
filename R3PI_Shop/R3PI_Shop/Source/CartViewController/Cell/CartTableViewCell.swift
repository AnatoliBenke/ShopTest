//
//  CartTableViewCell.swift
//  R3PI_Shop
//
//  Created by Anatoli Benke on 24.06.17.
//  Copyright © 2017 Private. All rights reserved.
//

import UIKit

@objc protocol CartTableViewCellDelegate: class {
    
    func didPressIncreaseAmountButton(on cell: CartTableViewCell)
    func didPressDecreaseAmountButton(on cell: CartTableViewCell)
}

class CartTableViewCell: UITableViewCell {

    // ==========================================================================
    // MARK: - Constants
    // ==========================================================================
    
    struct Constants {
        static let cellReuseID = "kCartTableViewCellReuseID"
        static let nibName     = "CartTableViewCell"
    }
    
    class var cellReuseID : String { get { return Constants.cellReuseID } }
    class var nibName : String { get { return Constants.nibName } }
    
    // ==========================================================================
    // MARK: - Outlets
    // ==========================================================================
    
    @IBOutlet fileprivate weak var productImageView:    UIImageView!
    @IBOutlet fileprivate weak var priceDeviderLine:    UIImageView!
    @IBOutlet fileprivate weak var cellDeviderLine:     UIImageView!
    
    @IBOutlet fileprivate weak var titleLabel:          UILabel!
    @IBOutlet fileprivate weak var subTitleLabel:       UILabel!
    
    @IBOutlet fileprivate weak var priceLabel:          UILabel!
    @IBOutlet fileprivate weak var priceTotalLabel:     UILabel!
    
    @IBOutlet fileprivate weak var decreaseButton:      UIButton!
    @IBOutlet fileprivate weak var increaseButton:      UIButton!
    
    @IBOutlet fileprivate var imageViewWidthConstraint:             NSLayoutConstraint!
    @IBOutlet fileprivate var imageViewLeftConstraintToSuperView:   NSLayoutConstraint!
    @IBOutlet fileprivate var titleLabelTopConstraintToImageView:   NSLayoutConstraint!
    
    // ==========================================================================
    // MARK: - Properties
    // ==========================================================================
    
    weak var delegate: CartTableViewCellDelegate?
    
    // ==========================================================================
    // MARK: - Cell Methods
    // ==========================================================================
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.setupTheme()
    }

    func setupCell(with cartItem: CartItem, cartMode: CartMode) {
        
        self.setupContent(with: cartItem, cartMode: cartMode)
        self.layout(for: cartMode)
    }
    
    // ==========================================================================
    // MARK: - Private Methods
    // ==========================================================================
    
    fileprivate func setupTheme() {
        
        ThemeManager.cartTableViewCellStyle(self)
        ThemeManager.cartTableViewCellImageViewStyle(self.productImageView)
        ThemeManager.cartTableViewPriceDeviderImageViewStyle(self.priceDeviderLine)
        ThemeManager.cartTableViewCellCellDeviderImageViewStyle(self.cellDeviderLine)
        
        ThemeManager.cartTableViewCellStyle(self)
        ThemeManager.cartTableViewCellTitleLabelStyle(self.titleLabel)
        ThemeManager.cartTableViewCellSubTitleLabelStyle(self.subTitleLabel)
        
        ThemeManager.cartTableViewCellPriceTotalLabelStyle(self.priceTotalLabel)
        ThemeManager.cartTableViewCellPriceLabelStyle(self.priceLabel)
        
        ThemeManager.cartTableViewCellDecreaseButtonStyle(self.decreaseButton)
        ThemeManager.cartTableViewCellIncreaseButtonStyle(self.increaseButton)
    }
    
    fileprivate func layout(for cartMode: CartMode) {
        
        switch cartMode {
        case .modify:
                self.layoutModeModify()
        case .checkout:
                self.layoutModeCheckout()
        }
    }
    
    fileprivate func setupContent(with cartItem: CartItem, cartMode: CartMode) {
        
        if let price = cartItem.product?.price {
            if let piecePrice = CurrencyManager.sharedInstance.currencyString(with: Double(price), currencyCode: CurrencyManager.sharedInstance.sourceCurrency!) {
                
                var priceLabelText: String = ""
                
                let connectorSymbol = " x "
                let resultSymbol = " = "
                
                switch cartMode {
                case .modify:
                    priceLabelText = "\(cartItem.amount)"
                    priceLabelText += connectorSymbol
                    priceLabelText += "\(piecePrice)"
                    break
                case .checkout:
                    priceLabelText = "\(cartItem.amount)"
                    priceLabelText += connectorSymbol
                    priceLabelText += "\(piecePrice)"
                    priceLabelText += resultSymbol
                    
                    if let totalprice = CurrencyManager.sharedInstance.currencyString(with: Double(price * Float(cartItem.amount)), currencyCode: CurrencyManager.sharedInstance.sourceCurrency!) {
                        priceLabelText += totalprice
                    }
                    break
                }
                
                self.priceLabel.text = "\(priceLabelText)"
            }
            else {
                self.priceLabel.text = ""
            }
            
            if let totalprice = CurrencyManager.sharedInstance.currencyString(with: Double(Double(price * Float(cartItem.amount))), currencyCode: CurrencyManager.sharedInstance.sourceCurrency!) {
                self.priceTotalLabel.text = totalprice
            }
            else {
                self.priceTotalLabel.text = ""
            }
            
            self.priceDeviderLine.isHidden = false
        }
        else {
            self.priceLabel.text = ""
            self.priceTotalLabel.text = ""
            self.priceDeviderLine.isHidden = true
        }
        
        
        if let title = cartItem.product?.title {
            self.titleLabel.text = title
        }
        else {
            self.titleLabel.text = ""
        }
        
        if let subTitle = cartItem.product?.desc {
            self.subTitleLabel.text = subTitle
        }
        else {
            self.subTitleLabel.text = ""
        }
        
        if let imageURLString = cartItem.product?.imageURL {
            self.productImageView.loadImageUsingCacheWithURLString(imageURLString, placeHolder: UIImage(named: "placeHolderImage"))
        }
    }
    
    // ==========================================================================
    // MARK: - Layouts
    // ==========================================================================
    
    fileprivate func layoutModeModify() {
        self.productImageView.isHidden = false
        self.priceDeviderLine.isHidden = false
        self.titleLabel.isHidden = false
        self.subTitleLabel.isHidden = false
        self.priceLabel.isHidden = false
        self.priceTotalLabel.isHidden = false
        self.decreaseButton.isHidden = false
        self.increaseButton.isHidden = false
        
        self.imageViewWidthConstraint.constant = 100.0
        self.imageViewLeftConstraintToSuperView.constant = 10.0
        self.titleLabelTopConstraintToImageView.constant = 20.0
    }
    
    fileprivate func layoutModeCheckout() {
        self.productImageView.isHidden = true
        self.priceDeviderLine.isHidden = true
        self.subTitleLabel.isHidden = true
        self.priceTotalLabel.isHidden = true
        self.decreaseButton.isHidden = true
        self.increaseButton.isHidden = true
        
        self.titleLabel.isHidden = false
        self.priceLabel.isHidden = false
        
        self.imageViewWidthConstraint.constant = 0.0
        self.imageViewLeftConstraintToSuperView.constant = 0.0
        self.titleLabelTopConstraintToImageView.constant = 0.0
    }
    
    // ==========================================================================
    // MARK: - IBActions
    // ==========================================================================
    
    @IBAction fileprivate func increaseButtonPressed(_ sender: UIButton) {
        self.delegate?.didPressIncreaseAmountButton(on: self)
    }
    
    @IBAction fileprivate func decreaseButtonPressed(_ sender: UIButton) {
        self.delegate?.didPressDecreaseAmountButton(on: self)
    }
}
