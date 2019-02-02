//
//  ConversionsModuleBuilder.swift
//  Rates
//
//  Created by Catherine Korovkina on 2/2/2562 BE.
//  Copyright © 2562 snm. All rights reserved.
//

import Foundation


class ConversionModuleInitializer: NSObject {
    @IBOutlet weak var viewController: ConversionsViewController!
    @IBOutlet weak var networkFactory: NetworkProvidersFactory!

    override func awakeFromNib() {
        ConversionsModuleBuilder().build(for: viewController, networkFactory: networkFactory)
    }
}

class ConversionsModuleBuilder {
    func build(for viewController: ConversionsViewController, networkFactory: NetworkProvidersFactory) {
        let presenter = ConversionsPresenter()
        let interactor = ConversionsInteractor()
        let networkProvider = networkFactory.ratesNetworkProvider()
        let converter = ConversionViewModelConverterImplementation()
        let dataStorage = DataStorageImplementation()
        converter.dataStorage = dataStorage
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.converter = converter
        presenter.view = viewController
        interactor.presenter = presenter
        interactor.networkProvider = networkProvider
    }
}
