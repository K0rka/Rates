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
        guard let currenciesArray = jsonDict["rates"] as? [[String: Double]] else {
            return []
        }
         var rates = [CurrencyRate]()
        
        currenciesArray.forEach { (nextDict) in
            let key = nextDict.keys.first ?? ""
            let value = nextDict[key]
            let rate = CurrencyRate(
                code: key,
                rate: value ?? 0.0)
            rates.append(rate)
        }
     
        return rates
    }
}
