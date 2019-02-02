//
//  CurrencyInfoMapper.swift
//  Rates
//
//  Created by Catherine Korovkina on 2/2/2562 BE.
//  Copyright © 2562 snm. All rights reserved.
//

import Foundation

protocol CurrencyInfoMapper {
    func map(jsonDict: [String: Any]) -> [String: String]
}

class CurrencyInfoMapperImplementation:  CurrencyInfoMapper {
    func map(jsonDict: [String: Any]) -> [String: String] {
        guard let result = jsonDict as? [String: String] else {
            return [:]
        }
        return result
    }
}
