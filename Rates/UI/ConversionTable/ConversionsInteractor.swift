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

    func stopUpdatingRates() {
        timer?.invalidate()
        timer = nil
    }
    
    func getCurrentRates() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {[weak self] (timer) in
            self?.fetchData()
        }
        timer?.fire()
    }
    
    fileprivate func fetchData() {
        networkProvider.getRates {[weak self] (rates, error) in
            guard let rates = rates  else {
                self?.presenter?.didFailToGetRates()
                return
            }
            if let _ = error {
                self?.presenter?.didFailToGetRates()
                return
            }
            self?.presenter?.didGet(rates: rates)
        }
    }
    
}
