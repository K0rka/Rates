//
//  InitialSetupInteractorTests.swift
//  RatesTests
//
//  Created by Catherine Korovkina on 3/2/2562 BE.
//  Copyright © 2562 snm. All rights reserved.
//

import XCTest

@testable import Rates

class InitialSetupInteractorTests: XCTestCase {

    let interactor = InitialSetupInteractor()
    
    override func setUp() {

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPerformSucccesfulSetup() {
        //given
        let dataStorage = MockDataStorage(hasCurrenciesInfo: false)
        let provider = MockNetworkProvider(shouldSucceed: true)
        interactor.dataStorage = dataStorage
        interactor.networkProvider = provider
        
        //when
        
        interactor.performSetup()
        
        //then
        XCTAssertTrue(dataStorage.didCallSave)
        XCTAssertTrue(provider.didCallCurrenciesInfo)
    }

    func testPerformSetupWhenDataExists() {
        //given
        let dataStorage = MockDataStorage(hasCurrenciesInfo: true)
        let provider = MockNetworkProvider(shouldSucceed: true)
        interactor.dataStorage = dataStorage
        interactor.networkProvider = provider
        
        //when
        
        interactor.performSetup()
        
        //then
        XCTAssertFalse(dataStorage.didCallSave)
        XCTAssertFalse(provider.didCallCurrenciesInfo)
    }
    
    func testPerformSetupWithFail() {
        //given
        let dataStorage = MockDataStorage(hasCurrenciesInfo: false)
        let provider = MockNetworkProvider(shouldSucceed: false)
        interactor.dataStorage = dataStorage
        interactor.networkProvider = provider
        let expectation = self.expectation(description: "SetupError")
        
        //when
        interactor.performSetup()
        let provider1 = MockNetworkProvider(shouldSucceed: true, expectation: expectation)
        interactor.networkProvider = provider1

        
        //then
        waitForExpectations(timeout: 11) { (error) in
            XCTAssertNil(error)
        }
        
        XCTAssertTrue(dataStorage.didCallSave)
    }
    
}

final private class MockDataStorage: DataStorage {
    
    let hasInfo: Bool

    init(hasCurrenciesInfo: Bool) {
        hasInfo = hasCurrenciesInfo
    }
    
    func hasCurrenciesInfo() -> Bool {
        return hasInfo
    }
    
    func retrieveCurrenciesInfo() -> [String : String] {
        return [:]
    }
    
    var didCallSave = false
    func save(currenciesInfo: [String : String]) {
        didCallSave = true
    }
    
}


final private class MockNetworkProvider: CurrencyInfoNetworkProvider {
    
    let shouldSucceed: Bool
    let expectation: XCTestExpectation?
    init(shouldSucceed: Bool, expectation: XCTestExpectation? = nil) {
        self.shouldSucceed = shouldSucceed
        self.expectation = expectation
    }
    
    var didCallCurrenciesInfo = false
    func getCurrenciesInfo(completion: @escaping ([String : String]?, Error?) -> Void) {
        didCallCurrenciesInfo = true
        
        if shouldSucceed {
            expectation?.fulfill()
            completion(["String": "Another String"], nil)
        }
        else {
            completion(nil, CurrenciesInfoError.couldntFetchInfo)
        }
    }
    
    
}
