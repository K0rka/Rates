//
//  CurrencyInfoMapperTests.swift
//  RatesTests
//
//  Created by Catherine Korovkina on 3/2/2562 BE.
//  Copyright © 2562 snm. All rights reserved.
//

import XCTest
@testable import Rates

class CurrencyInfoMapperTests: XCTestCase {

    let mapper = CurrencyInfoMapperImplementation()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMapping() {
        //given
        let dataToMap: [String: Any] = ["AED": "Description 1",
                                        "EUR": "Something",
                                        "RUB": "[1, 2, 3]"]
        //when
        let mapped = mapper.map(jsonDict: dataToMap)
        
        //then
        XCTAssertEqual(mapped.count, 3)
        XCTAssertEqual(mapped["AED"], "Description 1")
        XCTAssertEqual(mapped["EUR"], "Something")
        XCTAssertEqual(mapped["RUB"], "[1, 2, 3]")


    }
    
    func testWrongDataMapping() {
        //given
        let dataToMap: [String: Any] = ["AED": 19.0,
                                        "EUR": "Something",
                                        "RUB": [1, 2, 3]]
        //when
        let mapped = mapper.map(jsonDict: dataToMap)
        
        //then
        XCTAssertTrue(mapped.isEmpty)
    }


}
