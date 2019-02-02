//
//  InitialSetupInteractor.swift
//  Rates
//
//  Created by Catherine Korovkina on 2/2/2562 BE.
//  Copyright © 2562 snm. All rights reserved.
//

import Foundation

class InitialSetupInteractor {
    
    var networkProvider: CurrencyInfoNetworkProvider!
    
    func performSetup() {
        
        networkProvider.getCurrenciesInfo { (currencies, error) in
            guard let currencies = currencies else {
                
                return
            }
            if let _ = error {
                
            }
            
        }
        
    }
    
}
