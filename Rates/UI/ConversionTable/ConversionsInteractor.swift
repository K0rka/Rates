//
//  ConversionsInteractor.swift
//  Rates
//
//  Created by Catherine Korovkina on 2/2/2562 BE.
//  Copyright © 2562 snm. All rights reserved.
//

import Foundation

class ConversionsInteractor: ConversionsViewInteractorInput {
    
    var networkProvider: RatesNetworkProvider!
    weak var presenter: ConversionsViewInteractorOutput?
    
    var timer: Timer?
    var currentRates: [CurrencyRate] = [CurrencyRate]()
    func stopUpdatingRates() {
        timer?.invalidate()
        timer = nil
    }
    
    func fetchCurrentRates() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {[weak self] (timer) in
            self?.fetchData()
        }
        timer?.fire()
    }
    
    fileprivate func fetchData() {
        networkProvider.getRates {[weak self] (rates, error) in
            guard let rates = rates,
                    error == nil else {
                self?.presenter?.didFailToGetRates()
                return
            }
            // As we don't change base and don't get base back, let's add it manually
            self?.currentRates = rates+[CurrencyRate(code: "EUR", rate: 1)]
            self?.presenter?.didGet(rates: rates+[CurrencyRate(code: "EUR", rate: 1)])
        }
    }
    
}
