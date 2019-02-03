//
//  ConversionModuleBuilderTests.swift
//  RatesTests
//
//  Created by Catherine Korovkina on 3/2/2562 BE.
//  Copyright © 2562 snm. All rights reserved.
//

import XCTest
@testable import Rates

class ConversionModuleBuilderTests: XCTestCase {

    let moduleBuilder = ConversionsModuleBuilder()
    
    func testBuilder() {
        //given
        let controller = ConversionsViewController()
        
        //when
        moduleBuilder.build(for: controller, networkFactory: MockFactory())
        
        //then
        let presenter = controller.presenter as? ConversionsPresenter
        XCTAssertNotNil(presenter)
        let interactor = presenter?.interactor as? ConversionsInteractor
        XCTAssertNotNil(interactor)
        XCTAssertNotNil(presenter?.converter)
        XCTAssertNotNil(interactor?.networkProvider)
    }
}

final private class MockFactory: NetworkProvidersFactory {
    override func ratesNetworkProvider() -> RatesNetworkProvider {
        return MockRateProvider()
    }
    
    override func currencyInfoNetworkProvider() -> CurrencyInfoNetworkProvider {
        return MockCurrencyInfoProvider()
    }
}


final private class MockRateProvider: RatesNetworkProvider {
    func getRates(base: String, completion: @escaping ([CurrencyRate]?, Error?) -> Void) {
        
    }
}

final private class MockCurrencyInfoProvider: CurrencyInfoNetworkProvider {
    func getCurrenciesInfo(completion: @escaping ([String : String]?, Error?) -> Void) {
    
    }
    
}
