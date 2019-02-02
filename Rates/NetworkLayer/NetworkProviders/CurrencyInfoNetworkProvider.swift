//
//  CurrencyInfoNetworkProvider.swift
//  Rates
//
//  Created by Catherine Korovkina on 2/2/2562 BE.
//  Copyright © 2562 snm. All rights reserved.
//

import Foundation
import Alamofire

enum CurrenciesInfoError: Error {
    case couldntCreateURL
}

protocol CurrencyInfoNetworkProvider {
    
}

class CurrencyInfoNetworkProviderImplementation: CurrencyInfoNetworkProvider {
    
    private let baseUrl: String
    private let mapper: Any
    
    
    init(baseUrl: String,
         infoMapper: Any) {
        self.baseUrl = baseUrl
        mapper = infoMapper
    }
    
    func getCurrenciesInfo(completion: @escaping ([Any]?, Error?) -> Void) {
        let urlString = baseUrl + InfoEndpoints.currencies.rawValue
        guard let url = URL(string: urlString) else {
            completion(nil, CurrenciesInfoError.couldntCreateURL)
            return
        }
        Alamofire.request(url)
            .response {[weak self] (fullResponse) in
                
        }
    }
}
