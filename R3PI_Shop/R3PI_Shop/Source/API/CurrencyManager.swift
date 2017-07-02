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

class CurrencyManager: NSObject {
    
    // ==========================================================================
    // MARK: - Shared Instance
    // ==========================================================================
    
    static let sharedInstance = CurrencyManager()
    
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
    
    var currencyQuotes: [Quote]?
    
    // ==========================================================================
    // MARK: - API call Methods
    // ==========================================================================
    
    func currencyString(with price: Double, currencyCode: String) -> String? {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        currencyFormatter.currencyCode = currencyCode
        // Add spacer between currencySymbol and value
        currencyFormatter.positivePrefix = "\(currencyFormatter.positivePrefix!) "
        
        return currencyFormatter.string(from: NSNumber(value: price))
    }
    
    func getCurrencyQuotes(completion: @escaping (Result<[Quote]>) -> Void) {
        if let allQuotes = self.currencyQuotes {
            completion(.Success(allQuotes))
        }
        else {
            CurrencyManager.sharedInstance.setupCurrencyQuotas { result in
                
                switch result {
                case .Success(let quotes):
                    self.currencyQuotes = quotes
                    
                    completion(.Success(quotes))
                    break
                    
                case .Error(let error):
                    
                    completion(.Error(error))
                }
            }
        }
    }
    
    func setupCurrencyQuotas(completion: @escaping (Result<[Quote]>) -> Void) {
        
        CurrencyManager.sharedInstance.updateCurrencyRates { result in
            
            switch result {
            case .Success(let response):
                
                if let rawQuotes = response["quotes"] as? [String: Double] {
                    
                    var parsedQuotes = [Quote]()
                    
                    // Append SourceCurrencyQuote for the user to be able to exchange back to sourceCurrency
                    if let source = self.sourceCurrency {
                        let aQuote = Quote(currency: source, quote: 1.0)
                        parsedQuotes.append(aQuote)
                    }
                    
                    for (name, rate) in rawQuotes {
                        if let source = self.sourceCurrency {
                            
                            let currencyName = name.replacingOccurrences(of: source, with: "")
                            let aQuote = Quote(currency: currencyName, quote: rate)
                            parsedQuotes.append(aQuote)
                        }
                    }
                    completion(.Success(parsedQuotes))
                }
                
                break
                
            case .Error(let error):
                completion(.Error(error))
            }
        }
    }
    
    func updateCurrencyRates(completion: @escaping (Result<[String: Any]>) -> Void ) {
        
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
                    completion(.Error(error!))
                }
                else {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                        
                        if let _ = json[ParseKeys.Quotes], let _ = json[ParseKeys.SourceCurrency] {
                            
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
