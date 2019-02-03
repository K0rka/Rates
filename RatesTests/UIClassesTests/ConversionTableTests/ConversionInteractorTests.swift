//
//  ConversionInteractorTests.swift
//  RatesTests
//
//  Created by Catherine Korovkina on 3/2/2562 BE.
//  Copyright © 2562 snm. All rights reserved.
//

import XCTest
@testable import Rates

class ConversionInteractorTests: XCTestCase {

    let interactor = ConversionsInteractor()
    fileprivate let provider = MockNetworkProvider()
    fileprivate let presenter = MockPresenter()
    
    override func setUp() {
        interactor.presenter = presenter
        interactor.networkProvider = provider
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStartFetch() {
        //given
        provider.shouldSucceed = true
        let expectation = self.expectation(description: "Wait for timer")
        
        //when
        interactor.fetchCurrentRates()
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (timer) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 7, handler: nil)

        //then
        XCTAssert(presenter.numberOfSuccessfulCalls > 4)
    }

    func testFetchWithError() {
        //given
        provider.shouldSucceed = false
        
        //when
        interactor.fetchCurrentRates()
        
        //then
        XCTAssert(presenter.didCallFail)
    }
    
    func testStopFetching() {
        //given
        provider.shouldSucceed = true
        let expectation = self.expectation(description: "Wait for timer")
        interactor.fetchCurrentRates()

        //when
        interactor.stopUpdatingRates()
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (timer) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 7, handler: nil)

        //then
        XCTAssert(presenter.numberOfSuccessfulCalls < 2)
    }
}


final private class MockPresenter: ConversionsViewInteractorOutput {
    var didCallFail = false
    func didFailToGetRates() {
        didCallFail = true
    }
    
    var didGetRates = false
    var numberOfSuccessfulCalls = 0
    func didGet(rates: [CurrencyRate]) {
        numberOfSuccessfulCalls += 1
        didGetRates = true
    }
    
    
}

final private class MockNetworkProvider: RatesNetworkProvider {
    
    var shouldSucceed: Bool = true
    
    func getRates(base: String, completion: @escaping ([CurrencyRate]?, Error?) -> Void) {
        if shouldSucceed {
            completion([CurrencyRate(code: "Code", rate: 42)], nil)
        } else {
            completion(nil, RatesNetworkError.couldntFetchResults)
        }
    }
}
