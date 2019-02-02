//
//  NetworkProvidersFactory.swift
//
//  Created on 15/1/2562 BE.
//  Copyright © 2562 snm. All rights reserved.
//

import UIKit

enum HTTPStatusCode: Int {
    case created = 201
    case success = 200
}

class NetworkProvidersFactory: NSObject {

    func settings() -> NSDictionary? {
        var nsDictionary: NSDictionary?
        if let path = Bundle.main.path(forResource: "APIConstants", ofType: "plist") {
            nsDictionary = NSDictionary(contentsOfFile: path)
        }
        return nsDictionary
    }
    
    func ratesNetworkProvider() -> RatesNetworkProvider {
        let mapper = CurrencyRatesMapperImplementation()
        let dictionary = settings()
        let pricingProvider = RatesNetworkProviderImplementation(
            baseUrl: dictionary?["BaseRatesURL"] as? String ?? "",
            ratesMapper: mapper)
        
        return pricingProvider
    }
    
    func currencyInfoNetworkProvider() -> CurrencyInfoNetworkProvider {
        let dictionary = settings()
        let provider = CurrencyInfoNetworkProviderImplementation(
        baseUrl: dictionary?["CurrencyInfoBaseURL"] as? String ?? "",
        infoMapper: CurrencyInfoMapperImplementation())
        
        return provider
    }
    
}
