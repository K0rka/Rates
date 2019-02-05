//
//  ConversionsProtocols.swift
//  Rates
//
//  Created by Catherine Korovkina on 2/2/2562 BE.
//  Copyright © 2562 snm. All rights reserved.
//

import Foundation

protocol ConversionsViewInput: class {
    func showNoResultsView()
    func showLoading()
    func show(rates: [ConversionRateViewModel])
    func updateDataSource(rates: [ConversionRateViewModel])
}

protocol ConversionsViewOutput {
    func viewIsReady()
    func viewIsHiding()
    func viewDidFinishEditing()
    func wantToEdit(conversionModel: ConversionRateViewModel)
}

protocol ConversionsViewInteractorInput {
    func fetchCurrentRates()
    func stopUpdatingRates()
    var currentRates: [CurrencyRate] {get}
}

protocol ConversionsViewInteractorOutput: class {
    func didFailToGetRates()
    func didGet(rates: [CurrencyRate])
}
