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
    
    @IBOutlet fileprivate weak var imageView:       UIImageView!
    
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
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        // Save to force unwrap here, because fallback handling is done
        formatter.locale = Locale(identifier: AppConfigurationManager.sharedInstance.defaultDisplayCurrencyLocale!)
        
        self.titleLabel.text = product.title
        self.subTitleLabel.text = product.desc
        
        if let price = formatter.string(from: NSNumber(value: product.price)) {
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

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func animateView(_ view: UIView, fromRect: CGRect, toRect: CGRect) {
        
        let k = fromRect.origin.x > toRect.origin.x ? CGFloat(1.0) : CGFloat(-1.0)
        let anim = CAKeyframeAnimation(keyPath: "position.x")
        let a = fromRect.origin.x + fromRect.size.width * 0.5
        let b = toRect.origin.x + k * 20 + toRect.size.width * 0.5
        let c = toRect.origin.x - k * 10 + toRect.size.width * 0.5
        let d = toRect.origin.x + toRect.size.width * 0.5
        anim.values = [a, b, c, d]
        
        anim.duration = 0.8
        anim.isRemovedOnCompletion = true
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        view.layer.add(anim, forKey: "move_anim")
        
        view.frame = toRect
    }
    
    /*
     
     - (void)animateView:(UIView *)aView fromRect:(CGRect)fromRect toRect:(CGRect)toRect
     {
     int k = fromRect.origin.x > toRect.origin.x ? -1 : 1;
     CAKeyframeAnimation* anim = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
     anim.values = [NSArray arrayWithObjects:
     [NSNumber numberWithFloat:fromRect.origin.x + fromRect.size.width * 0.5f],
     [NSNumber numberWithFloat:toRect.origin.x + k * 20 + toRect.size.width * 0.5f],
     [NSNumber numberWithFloat:toRect.origin.x - k * 10 + toRect.size.width * 0.5f],
     [NSNumber numberWithFloat:toRect.origin.x + toRect.size.width * 0.5f], nil];
     anim.duration = 0.8f;
     anim.removedOnCompletion = true;
     anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
     [aView.layer addAnimation:anim forKey:@"move_anim"];
     aView.frame = toRect;
     }
    
    
    
    */

}
