//
//  ShopLabel.swift
//  R3PI_Shop
//
//  Created by Anatoli Benke on 24.06.17.
//  Copyright © 2017 Private. All rights reserved.
//

import UIKit

class ShopLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var leftInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 0.0
    
    var edgeInsets: UIEdgeInsets? = nil {
        didSet {
            if let edgeInsets = self.edgeInsets {
                self.topInset = edgeInsets.top
                self.bottomInset = edgeInsets.bottom
                self.leftInset = edgeInsets.left
                self.rightInset = edgeInsets.right
            }
        }
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: self.topInset, left: self.leftInset, bottom: self.bottomInset, right: self.rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            if let text = self.text, text.isEmpty {
                return CGSize.zero
            }
            var contentSize = super.intrinsicContentSize
            contentSize.height += self.topInset + self.bottomInset
            contentSize.width += self.leftInset + self.rightInset
            return contentSize
        }
    }

}
