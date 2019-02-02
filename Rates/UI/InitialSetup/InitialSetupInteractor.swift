//
//  InitialSetupInteractor.swift
//  Rates
//
//  Created by Catherine Korovkina on 2/2/2562 BE.
//  Copyright © 2562 snm. All rights reserved.
//

import Foundation

class InitialSetupLauncher: NSObject {
    
    @IBOutlet weak var networkFactory: NetworkProvidersFactory!
    var interactor: InitialSetupInteractor!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        interactor = InitialSetupInteractor()
        let networkProvider = networkFactory.currencyInfoNetworkProvider()
        let dataStorage = DataStorageImplementation()
        interactor.networkProvider = networkProvider
        interactor.dataStorage = dataStorage
        interactor.performSetup()
    }
    
    deinit {
        print("something")
    }
}

class InitialSetupInteractor {
    
    var networkProvider: CurrencyInfoNetworkProvider!
    var dataStorage: DataStorage!
    
    func performSetup() {
        guard !dataStorage.hasCurrenciesInfo() else {
            return
        }
        networkProvider.getCurrenciesInfo {[weak self] (currencies, error) in
            guard let currenciesInfo = currencies,
                error == nil else {
                self?.retrySetup()
                return
            }
            self?.dataStorage.save(currenciesInfo: currenciesInfo)
        }
    }
    
    func retrySetup() {
        Timer.scheduledTimer(withTimeInterval: 10, repeats: false) {[weak self] (timer) in
            self?.performSetup()
            timer.invalidate()
        }
    }
    
}
