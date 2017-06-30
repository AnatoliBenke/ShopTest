//
//  AppConfigurationManager.swift
//  R3PI_Shop
//
//  Created by Anatoli Benke on 25.06.17.
//  Copyright © 2017 Private. All rights reserved.
//

import UIKit
import CoreData

enum ConfigResult <T> {
    case Success(T)
    case Error(Error)
}

class AppConfigurationManager: NSObject {

    // ==========================================================================
    // MARK: - Shared Instance
    // ==========================================================================
    
    static let sharedInstance = AppConfigurationManager()
    
    // ==========================================================================
    // MARK: - Constants
    // ==========================================================================
    
    fileprivate struct ServiceUrls {
        static let ApiKey               = "65e02c846be42c22bf91a1bd89738709"
        static let BaseURL              = "http://apilayer.net/api/"
        static let EndPoint             = "live"
    }
    
    fileprivate struct ParamKeys {
        static let AccessKey            = "access_key"
        static let SourceCurrency       = "source"
        static let Currencies           = "currencies"
        static let Format               = "format"
    }
    
    fileprivate struct ParseKeys {
        static let Configuration                = "configuration"
        static let Currency_api_key             = "currency_api_key"
        static let Available_currencies         = "available_currencies"
        static let Products                     = "products"
        static let SourceCurrency               = "sourceCurrency"
    }
    
    
    
    func loadAppConfiguration(completion: @escaping (ConfigResult<Any?>) -> Void ) {
        if let path = Bundle.main.path(forResource: "AppConfig", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                
                
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any> {
                    
                    // Load products from configurationFile
                    if let rawProducts = jsonResult[ParseKeys.Products] as? Array<Dictionary<String, Any>> {
                       // CoreDataStack.sharedInstance.clearProductData()
                        
                        
                        CoreDataStack.sharedInstance.createUpdateOrDeleteProducts(with: rawProducts)
                    }
                    
                    if let rawConfig = jsonResult[ParseKeys.Configuration] as? Dictionary<String, Any> {
                        
                        if let apiKey = rawConfig[ParseKeys.Currency_api_key] as? String {
                            CurrencyApiManager.sharedInstance.apiKey = apiKey
                        }
                        
                        if let availableCurrencies = rawConfig[ParseKeys.Available_currencies] as? Array<String> {
                            CurrencyApiManager.sharedInstance.availableCurrencies = availableCurrencies
                        }
                        
                        if let sourceCurrency = rawConfig[ParseKeys.SourceCurrency] as? String {
                            CurrencyApiManager.sharedInstance.sourceCurrency = sourceCurrency
                        }
                        
                        completion(.Success(nil))
                    }
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
        else {
            print("Invalid filename/path.")
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
