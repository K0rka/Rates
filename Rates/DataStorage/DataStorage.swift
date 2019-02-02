//
//  DataStorage.swift
//  Rates
//
//  Created by Catherine Korovkina on 2/2/2562 BE.
//  Copyright © 2562 snm. All rights reserved.
//

import Foundation


protocol DataStorage {
    func save(currenciesInfo: [String: String])
    func retrieveCurrenciesInfo() -> [String: String]
    func hasCurrenciesInfo() -> Bool
}

class DataStorageImplementation: DataStorage {
    
    func save(currenciesInfo: [String: String]) {
        UserDefaults.standard.set(currenciesInfo, forKey: "CurrenciesInfo")
        UserDefaults.standard.set(true, forKey: "HasCurrenciesInfo")
    }
    
    func retrieveCurrenciesInfo() -> [String: String] {
        return UserDefaults.standard.dictionary(forKey: "CurrenciesInfo") as? [String: String] ?? [:]
    }
    
    func hasCurrenciesInfo() -> Bool {
        return UserDefaults.standard.bool(forKey: "HasCurrenciesInfo")
    }
}
