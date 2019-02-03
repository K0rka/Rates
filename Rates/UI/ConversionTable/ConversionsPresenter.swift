//
//  ConversionsPresenter.swift
//  Rates
//
//  Created by Catherine Korovkina on 2/2/2562 BE.
//  Copyright © 2562 snm. All rights reserved.
//

import UIKit

class ConversionsPresenter: NSObject, ConversionsViewOutput, ConversionsViewInteractorOutput {

    var interactor: ConversionsViewInteractorInput!
    weak var view: ConversionsViewInput!
    var converter: ConversionViewModelConverter!
    var multiplier: Double = 1
//    var showedData: [ConversionRateViewModel]
    
    func viewIsReady() {
        interactor.fetchCurrentRates()
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
        } else {
            let data = converter.convert(rates: rates, multiplier: multiplier, conversionDelegate: self)
            view.show(rates: data)
        }
    }
}

extension ConversionsPresenter: CurrencyValueChangeDelegate {
    func text(willChangeTo newText: String, for currencyViewModel: ConversionRateViewModel?) {
        let newValue = Double(newText) ?? 0

        guard let viewModel = currencyViewModel,
            let rate = interactor.currentRates.first(where: { (rate) -> Bool in
                rate.code == viewModel.code
            }) else {
                
            return
        }
        multiplier = newValue/rate.rate
        didGet(rates: interactor.currentRates)
    }
    

}
