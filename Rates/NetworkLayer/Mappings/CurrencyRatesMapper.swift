//
//  CurrencyRatesMapper.swift
//  Rates
//
//  Created by Catherine Korovkina on 2/2/2562 BE.
//  Copyright © 2562 snm. All rights reserved.
//

import Foundation

protocol CurrencyRatesMapper {
    func map(jsonDict: [String: Any]) -> [CurrencyRate]
}

class CurrencyRatesMapperImplementation: CurrencyRatesMapper {
    func map(jsonDict: [String: Any]) -> [CurrencyRate] {
        guard let currenciesDict = jsonDict["rates"] as? [String: Double] else {
            return []
        }
        var rates = [CurrencyRate]()
        
        currenciesDict.forEach { (key, value) in
            let rate = CurrencyRate(
                code: key,
                rate: value)
            rates.append(rate)
            
        }
        
        
        return rates
    }
}
