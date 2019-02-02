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
    case couldntFetchInfo
}

protocol CurrencyInfoNetworkProvider {
    func getCurrenciesInfo(completion: @escaping ([String: String]?, Error?) -> Void)
}

class CurrencyInfoNetworkProviderImplementation: CurrencyInfoNetworkProvider {
    
    private let baseUrl: String
    private let mapper: CurrencyInfoMapper
    
    
    init(baseUrl: String,
         infoMapper: CurrencyInfoMapper) {
        self.baseUrl = baseUrl
        mapper = infoMapper
    }
    
    func getCurrenciesInfo(completion: @escaping ([String: String]?, Error?) -> Void) {
        let urlString = baseUrl + InfoEndpoints.currencies.rawValue
        guard let url = URL(string: urlString) else {
            completion(nil, CurrenciesInfoError.couldntCreateURL)
            return
        }
        Alamofire.request(url)
            .response {[weak self] (response) in
                do {
                    guard let data = response.data,
                        let jsonDict = try JSONSerialization.jsonObject(
                            with: data, options: .mutableContainers) as? [String: Any] else {
                                completion(nil, CurrenciesInfoError.couldntFetchInfo)
                                return
                    }
                    
                    let result = self?.mapper.map(jsonDict: jsonDict)
                    completion(result, nil)
                    
                } catch {
                    completion(nil, CurrenciesInfoError.couldntFetchInfo)
                }
        }
    }
}
