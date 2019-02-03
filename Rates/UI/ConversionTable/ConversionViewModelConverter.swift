//
//  ConversionViewModelConverter.swift
//  Rates
//
//  Created by Catherine Korovkina on 2/2/2562 BE.
//  Copyright © 2562 snm. All rights reserved.
//

import UIKit


protocol ConversionViewModelConverter {
    func convert(rates: [CurrencyRate], multiplier: Double, conversionDelegate: CurrencyValueChangeDelegate?)-> [ConversionRateViewModel]
    func convert(rates: [CurrencyRate])-> [ConversionRateViewModel]
    func convert(rates: [CurrencyRate], conversionDelegate: CurrencyValueChangeDelegate?)-> [ConversionRateViewModel]
    func convert(rates: [CurrencyRate], multiplier: Double)-> [ConversionRateViewModel]

}

extension ConversionViewModelConverter {
    func convert(rates: [CurrencyRate])-> [ConversionRateViewModel] {
        return convert(rates: rates, multiplier: 1, conversionDelegate: nil)
    }
    
    func convert(rates: [CurrencyRate], conversionDelegate: CurrencyValueChangeDelegate?)-> [ConversionRateViewModel] {
        return convert(rates: rates, multiplier: 1, conversionDelegate: conversionDelegate)
    }
    
    func convert(rates: [CurrencyRate], multiplier: Double)-> [ConversionRateViewModel] {
        return convert(rates: rates, multiplier: multiplier, conversionDelegate: nil)
    }

}

class ConversionViewModelConverterImplementation: ConversionViewModelConverter {
    
    var dataStorage: DataStorage!
    
    func convert(rates: [CurrencyRate], multiplier: Double, conversionDelegate: CurrencyValueChangeDelegate?) -> [ConversionRateViewModel] {
        var result = [ConversionRateViewModel]()
        let info = dataStorage.retrieveCurrenciesInfo()
        
        rates.forEach { (currencyRate) in
            let rateValue = currencyRate.rate * multiplier
            let rateString = rateValue > 0 ?
                rateFormatter().string(from: NSNumber(value: rateValue)) :
            ""
            
            let vm = ConversionRateViewModel(image: UIImage(named: currencyRate.code.lowercased()),
                                             rate: rateString ?? "",
                                             code: currencyRate.code,
                                             name: info[currencyRate.code] ?? "",
                                             conversionDelegate: conversionDelegate
            )
            
            result.append(vm)
        }
        
        return result.sorted()
    }
    
    private func rateFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.decimalSeparator = "."
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 3
        formatter.numberStyle = .decimal
        return formatter
    }

}
