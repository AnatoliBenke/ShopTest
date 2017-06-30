//
//  Quote.swift
//  R3PI_Shop
//
//  Created by Anatoli Benke on 30/6/2017.
//  Copyright © 2017 Private. All rights reserved.
//

import UIKit

struct Quote {
    var currency: String
    var quote: Double
    
    init(currency: String, quote: Double) {
        self.currency = currency
        self.quote = quote
    }
}
