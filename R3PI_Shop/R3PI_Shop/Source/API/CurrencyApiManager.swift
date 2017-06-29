//
//  CurrencyApiManager.swift
//  R3PI_Shop
//
//  Created by Anatoli Benke on 25.06.17.
//  Copyright © 2017 Private. All rights reserved.
//

import UIKit

enum Result <T>{
    case Success(T)
    case Error(Error)
}

class CurrencyApiManager: NSObject {
    
    // ==========================================================================
    // MARK: - Shared Instance
    // ==========================================================================
    
    static let sharedInstance = CurrencyApiManager()
    
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
    
    fileprivate struct ParamValues {
        static let responseFormatJSON   = "1"
    }
    
    fileprivate struct ParseKeys {
        static let Quotes               = "quotes"
        static let SourceCurrency       = "source"
    }
    
    // ==========================================================================
    // MARK: - Variables
    // ==========================================================================
    
    var apiKey: String?
    var availableCurrencies: Array<String>?
    var sourceCurrency: String?
    
    // ==========================================================================
    // MARK: - API call Methods
    // ==========================================================================
    
    func updateCurrencyRates(completion: @escaping (Result<[String: AnyObject]>) -> Void ) {
        
        guard let myApiKey = self.apiKey else {
            print("Load App Configuration first")
            return
        }
        
        guard let myAvailableCurrencies = self.availableCurrencies else {
            print("Load App Configuration first")
            return
        }
        
        guard let mySourceCurrency = self.sourceCurrency else {
            print("Load App Configuration first")
            return
        }
        
        var urlString = ServiceUrls.BaseURL + ServiceUrls.EndPoint
        
        var parameters : [String : Any] = [String : Any]()
        
        parameters[ParamKeys.AccessKey]         = myApiKey
        parameters[ParamKeys.SourceCurrency]    = mySourceCurrency
        parameters[ParamKeys.Currencies]        = myAvailableCurrencies.joined(separator: ",")
        parameters[ParamKeys.Format]            = ParamValues.responseFormatJSON
        
        if let paramsString = self.getParameterURL(from: parameters) {
            urlString += paramsString
        }
        
        if let requestURL = URL(string: urlString) {
            
            URLSession.shared.dataTask(with: requestURL, completionHandler: { (data, response, error) in
                
                if(error != nil) {
                    print("error")
                }
                else {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                        
                        if let quotes = json[ParseKeys.Quotes], let sourceCurrency = json[ParseKeys.SourceCurrency] {
                            
                            
                            OperationQueue.main.addOperation({
                                completion(.Success(json))
                            })
                        }
                        
                        
                        
                    } catch let error as NSError{
                        print(error)
                        completion(.Error(error))
                    }
                }
            }).resume()
        }
    }
    
    // ==========================================================================
    // MARK: - Private Methods
    // ==========================================================================
    
    fileprivate func getParameterURL(from dictionary: [String : Any]?) -> String? {
        
        guard let dictionary = dictionary else { return nil }
        
        var paramsURL = ""
        
        let keys = Array(dictionary.keys)
        for aKey in keys {
            var glue = ""
            if keys.index(of: aKey) == 0 {
                glue = "?"
            }
            else {
                glue = "&"
            }
            
            if let aParam = dictionary[aKey] {
                paramsURL += "\(glue)\(aKey)=\(String(describing: aParam))"
            }
        }
        
        return paramsURL
    }
    
    
    
    
}
