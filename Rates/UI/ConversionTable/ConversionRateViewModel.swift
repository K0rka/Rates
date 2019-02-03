//
//  ConversionRateViewModel.swift
//  Rates
//
//  Created by Catherine Korovkina on 2/2/2562 BE.
//  Copyright © 2562 snm. All rights reserved.
//

import UIKit

struct ConversionRateViewModel {
    let image: UIImage?
    let rate: String
    let code: String
    let name: String
    let conversionDelegate: CurrencyValueChangeDelegate?
}

extension ConversionRateViewModel: Comparable {
    static func < (lhs: ConversionRateViewModel, rhs: ConversionRateViewModel) -> Bool {
        return lhs.code < rhs.code
    }
    
    static func == (lhs: ConversionRateViewModel, rhs: ConversionRateViewModel) -> Bool {
        return lhs.code == rhs.code
    }
    
    
}
