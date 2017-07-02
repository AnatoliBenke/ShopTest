//
//  NavigationController+Animation.swift
//  R3PI_Shop
//
//  Created by Anatoli Benke on 2/7/2017.
//  Copyright © 2017 Private. All rights reserved.
//

import UIKit

extension UINavigationController {

    func animateView(_ view: UIView, fromRect: CGRect, toRect: CGRect) {
        
        // Copy view
        if let viewToMove = view.copyView() as? UIView {
            viewToMove.frame = fromRect
            self.view.addSubview(viewToMove)
            self.view.bringSubview(toFront: viewToMove)
            
            UIView.animate(withDuration: 0.3, animations: {
                viewToMove.frame = toRect
                viewToMove.alpha = 0.1
                
            }) { finished in
                if finished {
                    viewToMove.removeFromSuperview()
                }
            }
        }
    }
}
