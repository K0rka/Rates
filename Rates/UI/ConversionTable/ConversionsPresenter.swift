//
//  ConversionsPresenter.swift
//  Rates
//
//  Created by Catherine Korovkina on 2/2/2562 BE.
//  Copyright © 2562 snm. All rights reserved.
//

import Foundation

class ConversionsPresenter: ConversionsViewOutput, ConversionsViewInteractorOutput {

    var interactor: ConversionsViewInteractorInput!
    weak var view: ConversionsViewInput!
    
    func viewIsReady() {
        interactor.getCurrentRates()
        view.showLoading()
    }
    
    func viewIsHiding() {
        interactor.stopUpdatingRates()
    }
    
    func didFailToGetRates() {
        view.showNoResultsView()
    }
    
    func didGet(rates: [CurrencyRate]) {
        if rates.isEmpty {
            view.showNoResultsView()
        }
    }
    
}
