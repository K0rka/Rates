//
//  RatesNetworkProvider.swift
//
//  Created on 15/1/2562 BE.
//  Copyright © 2562 snm. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

enum RatesNetworkError: Error {
    case couldntCreateURL
    case couldntFetchResults
}

protocol RatesNetworkProvider {
    func getRates(completion: @escaping ([CurrencyRate]?, Error?) -> Void)
    func getRates(base: String, completion: @escaping ([CurrencyRate]?, Error?) -> Void)
}

extension RatesNetworkProvider {
    func getRates(completion: @escaping ([CurrencyRate]?, Error?) -> Void) {
        getRates(base: "EUR", completion: completion)
    }
}

class RatesNetworkProviderImplementation: RatesNetworkProvider {

    private let baseUrl: String
    private let mapper: CurrencyRatesMapper

    
    init(baseUrl: String,
        ratesMapper: CurrencyRatesMapper) {
        self.baseUrl = baseUrl
        mapper = ratesMapper
    }

    func getRates(base: String, completion: @escaping ([CurrencyRate]?, Error?) -> Void) {
        let urlString = baseUrl + RatesEndpoints.latest.rawValue
        let parameters = ["base": base]
        guard let url = URL(string: urlString) else {
            completion(nil, RatesNetworkError.couldntCreateURL)
            return
        }
        Alamofire.request(url,
                          method: HTTPMethod.get,
                          parameters: parameters)
            .response {[weak self] (response) in
                do {
                    guard let data = response.data,
                        let jsonDict = try JSONSerialization.jsonObject(
                            with: data, options: .mutableContainers) as? [String: Any] else {
                        completion(nil, RatesNetworkError.couldntFetchResults)
                        return
                    }
                    
                    let result = self?.mapper.map(jsonDict: jsonDict)
                    completion(result, nil)
                    
                } catch {
                    completion(nil, RatesNetworkError.couldntFetchResults)
                }
                
        }
    }
}
