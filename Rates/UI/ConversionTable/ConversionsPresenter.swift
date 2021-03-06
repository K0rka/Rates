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
    var isViewResponsible = true
    var editingViewModel: ConversionRateViewModel?
    
    func viewIsReady() {
        interactor.fetchCurrentRates()
        view.showLoading()
    }
    
    func viewIsHiding() {
        interactor.stopUpdatingRates()
    }
    
    func viewDidFinishEditing() {
        if multiplier == 0 {
            multiplier = 1
            didGet(rates: interactor.currentRates)
        }
    }

    func wantToEdit(conversionModel: ConversionRateViewModel) {
        editingViewModel = conversionModel
        isViewResponsible = false
        let data = converter.convert(rates: interactor.currentRates, multiplier: multiplier, conversionDelegate: self, editingViewModel: editingViewModel)
        view.updateDataSource(rates: data)
    }

    func didFailToGetRates() {
        view.showNoResultsView()
    }
    
    func didGet(rates: [CurrencyRate]) {
        if rates.isEmpty {
            view.showNoResultsView()
        } else {
            guard isViewResponsible else {
                return
            }
            let data = converter.convert(rates: rates, multiplier: multiplier, conversionDelegate: self, editingViewModel: editingViewModel)
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
    
    func transitionStarted() {
        isViewResponsible = false
    }
    
    func transitionEnded() {
        isViewResponsible = true
    }

}
