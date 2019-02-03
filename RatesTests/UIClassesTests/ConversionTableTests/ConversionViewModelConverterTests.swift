//
//  ConversionViewModelConverterTests.swift
//  RatesTests
//
//  Created by Catherine Korovkina on 3/2/2562 BE.
//  Copyright © 2562 snm. All rights reserved.
//

import XCTest
@testable import Rates

class ConversionViewModelConverterTests: XCTestCase {

    let converter = ConversionViewModelConverterImplementation()
    
    override func setUp() {
        let dataStorage = MockDataStorage()
        converter.dataStorage = dataStorage
    }

    func testValidConversion() {
        //given
        let data = [CurrencyRate(code: "Code", rate: 1),
                    CurrencyRate(code: "Another", rate: 2)]
        //when
        let viewModels = converter.convert(rates: data)
        
        //then
        XCTAssertEqual(viewModels.count, 2)
        XCTAssertEqual(viewModels[1].code, "Code")
        XCTAssertEqual(viewModels[1].name, "Full code name")
        XCTAssertEqual(viewModels[0].code, "Another")
        XCTAssertEqual(viewModels[0].name, "Another name")
        XCTAssertEqual(viewModels[0].rate, "2")
    }
    
    func testValidConversionWithMultiplier() {
        //given
        let data = [CurrencyRate(code: "Code", rate: 1),
                    CurrencyRate(code: "Another", rate: 2)]
        //when
        let viewModels = converter.convert(rates: data, multiplier: 5)
        
        //then
        XCTAssertEqual(viewModels.count, 2)
        XCTAssertEqual(viewModels[1].rate, "5")
        XCTAssertEqual(viewModels[0].rate, "10")
    }
    
    func testValidConversionWithEmptyName() {
        //given
        let data = [CurrencyRate(code: "Code", rate: 1),
                    CurrencyRate(code: "Another", rate: 2),
                    CurrencyRate(code: "Strange name", rate: 2)]
        let delegate = MockDelegate()
        //when
        let viewModels = converter.convert(rates: data, conversionDelegate: delegate)
        
        //then
        XCTAssertEqual(viewModels.count, 3)
        XCTAssert(viewModels[2].name.isEmpty)
        XCTAssertNotNil(viewModels[0].conversionDelegate as? MockDelegate)
        XCTAssertNotNil(viewModels[1].conversionDelegate as? MockDelegate)
        XCTAssertNotNil(viewModels[2].conversionDelegate as? MockDelegate)
    }
    
    func testConversionWithZeroMultiplier() {
        //given
        let data = [CurrencyRate(code: "Code", rate: 1),
                    CurrencyRate(code: "Another", rate: 2)]
        //when
        let viewModels = converter.convert(rates: data, multiplier: 0)
        
        //then
        XCTAssertEqual(viewModels.count, 2)
        XCTAssertEqual(viewModels[1].rate, "")
        XCTAssertEqual(viewModels[0].rate, "")

    }
}


final private class MockDelegate: CurrencyValueChangeDelegate {
    func transitionStarted() {
        
    }
    
    func transitionEnded() {
        
    }
    
    func text(willChangeTo newText: String, for currencyViewModel: ConversionRateViewModel?) {
    }
}

final private class MockDataStorage: DataStorage {
    func hasCurrenciesInfo() -> Bool {
        return true
    }
    
    func retrieveCurrenciesInfo() -> [String : String] {
        return ["Code": "Full code name",
                "Another": "Another name"]
    }
    
    func save(currenciesInfo: [String : String]) {
    }
}
