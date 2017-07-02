//
//  CheckoutHeaderView.swift
//  R3PI_Shop
//
//  Created by Anatoli Benke on 30/6/2017.
//  Copyright © 2017 Private. All rights reserved.
//

import UIKit

@objc protocol CheckoutHeaderViewDelegate: class {
    
    func didPressCancelButton()
    func didPressProceedButton()
    
    func didPressChangeCurrencyButton()
    
    @objc optional func errorLoadingExchangeRates(error: Error)
}

class CheckoutHeaderView: UIView {
    
    //==========================================================================
    //MARK:- Constants
    //==========================================================================
    
    struct Constants {
        static let NibName: String =        "CheckoutHeaderView"
        static let Height: CGFloat =        140.0
        static let HeightiPad: CGFloat =    180.0
    }
    
    // ==========================================================================
    // MARK: - Properties
    // ==========================================================================
    
    weak var delegate: CheckoutHeaderViewDelegate?
    
    //==========================================================================
    //MARK:- Outlets
    //==========================================================================
    
    @IBOutlet fileprivate weak var prefixLabel:             UILabel!
    @IBOutlet fileprivate weak var totalPriceLabel:         UILabel!
    
    @IBOutlet fileprivate weak var changeCurrencyButton:    UIButton!
    @IBOutlet fileprivate weak var proceedButton:           UIButton!
    @IBOutlet fileprivate weak var cancelButton:            UIButton!
    
    @IBOutlet fileprivate weak var activityIndicator:       UIActivityIndicatorView!
    
    //==========================================================================
    //MARK:- ViewController
    //==========================================================================
    
    class func newInstance() -> CheckoutHeaderView {
        let controller = Bundle.main.loadNibNamed(Constants.NibName, owner: self, options: nil)?.first
        return controller as! CheckoutHeaderView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupTheme()
    }
    
    func updateHeaderView(with totalPrice: Double, currencyCode: String) {
        
        self.activityIndicator.isHidden = false
        self.totalPriceLabel.isHidden = true
        CurrencyManager.sharedInstance.getCurrencyQuotes(completion: { (result) in
            self.activityIndicator.isHidden = true
            
            switch result {
            case .Success(let quotes):
                self.totalPriceLabel.isHidden = false
                var exchangeQuota = 1.0
                
                let filteredQuotes = quotes.filter{ element -> Bool in
                    if element.currency == currencyCode {
                        return true
                    }
                    
                    return false
                }
                
                if let selectedQuote = filteredQuotes.first {
                    exchangeQuota = selectedQuote.quote
                }
                
                if let totalprice = CurrencyManager.sharedInstance.currencyString(with: totalPrice * exchangeQuota, currencyCode: currencyCode) {
                    self.totalPriceLabel.text = totalprice
                }
                else {
                    self.totalPriceLabel.text = "error"
                }
                
                break
                
            case .Error(let error): break
                self.delegate?.errorLoadingExchangeRates?(error: error)
            }
        })
    }
    
    //==========================================================================
    //MARK:- Private Methods
    //==========================================================================

    fileprivate func setupTheme() {
        
        ThemeManager.checkoutHeaderViewStyle(self)
        
        ThemeManager.checkoutHeaderViewPrefixLabelStyle(self.prefixLabel)
        ThemeManager.checkoutHeaderViewPriceLabelStyle(self.totalPriceLabel)
        
        ThemeManager.checkoutHeaderViewChangeCurrencyButtonStyle(self.changeCurrencyButton)
        ThemeManager.checkoutHeaderViewCancelButtonStyle(self.cancelButton)
        ThemeManager.checkoutHeaderViewProceedButtonStyle(self.proceedButton)
    }

    // ==========================================================================
    // MARK: - IBActions
    // ==========================================================================
    
    @IBAction fileprivate func cancelButtonPressed(_ sender: UIButton) {
        self.delegate?.didPressCancelButton()
    }
    
    @IBAction fileprivate func proceedButtonPressed(_ sender: UIButton) {
        self.delegate?.didPressProceedButton()
    }
    
    @IBAction fileprivate func changeCurrencyPressed(_ sender: UIButton) {
        self.delegate?.didPressChangeCurrencyButton()
    }
}
