//
//  CurrencyRatesMapperTests.swift
//  RatesTests
//
//  Created by Catherine Korovkina on 3/2/2562 BE.
//  Copyright © 2562 snm. All rights reserved.
//

import XCTest
@testable import Rates


class CurrencyRatesMapperTests: XCTestCase {
    
    let mapper = CurrencyRatesMapperImplementation()

    func testValidDataMapping() {
        //given
        let data = ["rates": ["AED": 19.0,
                              "EUR": 0.234,
                              "RUB": 1290.8,
                              "AEP": 300]]
        
        //when
        let mapped = mapper.map(jsonDict: data)
        
        //then
        XCTAssertEqual(mapped.count, 4)
        mapped.forEach { (rate) in
            switch rate.code {
            case "AED":
                XCTAssertEqual(rate.rate, 19)
            case "EUR":
                XCTAssertEqual(rate.rate, 0.234)
            case "RUB":
                XCTAssertEqual(rate.rate, 1290.8)
            case "AEP":
                XCTAssertEqual(rate.rate, 300)
            default:
                XCTAssertTrue(true)
            }
        }
    }
    
    func testInvalidKeyDataMapping() {
        //given
        let data = ["data": ["AED": 19.0,
                              "EUR": 0.234,
                              "RUB": 1290.8,
                              "AEP": 300]]
        
        //when
        let mapped = mapper.map(jsonDict: data)
        
        //then
        XCTAssert(mapped.isEmpty)
    }
    
    
    func testInvalidInternalDataMapping() {
        //given
        let data = ["data": ["AED": "19.0",
                             "EUR": "0.234",
                             "RUB": "1290.8",
                             "AEP": "300"]]
        
        //when
        let mapped = mapper.map(jsonDict: data)
        
        //then
        XCTAssert(mapped.isEmpty)
    }
}
