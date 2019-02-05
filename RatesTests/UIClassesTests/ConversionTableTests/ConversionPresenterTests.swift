//
//  ConversionPresenterTests.swift
//  RatesTests
//
//  Created by Catherine Korovkina on 3/2/2562 BE.
//  Copyright © 2562 snm. All rights reserved.
//

import XCTest
@testable import Rates

class ConversionPresenterTests: XCTestCase {

    let presenter = ConversionsPresenter()
    fileprivate let view = MockView()
    fileprivate let interactor = MockInteractor()
    fileprivate let converter = MockConverter()
    
    override func setUp() {
        presenter.view = view
        presenter.interactor = interactor
        presenter.converter = converter
    }

    func testWantToEdit() {
        //given
        let viewModelToEdit = ConversionRateViewModel(image: nil, rate: "rate",
                                                      code: "One more",
                                                      name: "name", conversionDelegate: nil)
        //when
        presenter.wantToEdit(conversionModel: viewModelToEdit)
        
        //then
        XCTAssert(converter.didCallConvert)
        XCTAssert(view.didCallUpdateDatasource)
    }
    
    func testViewIsReady() {
        //given
        
        //when
        presenter.viewIsReady()
        
        //then
        XCTAssert(view.didCallShowLoading)
        XCTAssert(interactor.didCallFetchRates)
    }
    
    func testViewIsHiding() {
        //given
        
        //when
        presenter.viewIsHiding()
        
        //then
        XCTAssert(interactor.didCallStopUpdating)
    }
    
    func testDidFailToFetch() {
        //given
        
        //when
        presenter.didFailToGetRates()
        
        //then
        XCTAssert(view.didCallShowNoResults)
    }
    
    func testDidGetEmptyRates() {
        //given
        
        //when
        presenter.didGet(rates: [])
        
        //then
        XCTAssert(view.didCallShowNoResults)
    }
    
    func testDidGetResults() {
        //given
        
        //when
        presenter.didGet(rates: interactor.currentRates)
        
        //then
        XCTAssert(view.didCallShowRates)
        XCTAssert(converter.didCallConvert)
        XCTAssertEqual(converter.multiplier, 1)
    }
    
    func testDelegation() {
        //given
        
        //when
        presenter.text(willChangeTo: "56",
                       for: ConversionRateViewModel(image: nil, rate: "78", code: "One more", name: "String", conversionDelegate: nil))
        //then
        XCTAssert(converter.didCallConvert)
        XCTAssertEqual(converter.multiplier, 4)
        XCTAssert(view.didCallShowRates)
    }
    
    func testDelegationWithEmptyNewString() {
        //given
        
        //when
        presenter.text(willChangeTo: "",
                       for: ConversionRateViewModel(image: nil, rate: "78", code: "One more", name: "String", conversionDelegate: nil))
        //then
        XCTAssert(converter.didCallConvert)
        XCTAssertEqual(converter.multiplier, 0)
        XCTAssert(view.didCallShowRates)
    }
    
    func testDelegationWithWrongCode() {
        //given
        
        //when
        presenter.text(willChangeTo: "",
                       for: ConversionRateViewModel(image: nil, rate: "78", code: "One wrong code", name: "String", conversionDelegate: nil))
        //then
        XCTAssertFalse(converter.didCallConvert)
        XCTAssertFalse(view.didCallShowRates)
    }
    
    
    func testViewIsNotResponsible() {
        //given
        
        //when
        presenter.transitionStarted()
        presenter.didGet(rates: interactor.currentRates)
        
        //then
        XCTAssertFalse(view.didCallShowRates)
        
        //when
        presenter.transitionEnded()
        presenter.didGet(rates: interactor.currentRates)

        //then
        XCTAssert(view.didCallShowRates)
    }
    
    
    func testViewDidEndEditing() {
        //given
        presenter.multiplier = 0
        
        //when
        presenter.viewDidFinishEditing()
        
        //then
        XCTAssertEqual(presenter.multiplier, 1)
        XCTAssert(view.didCallShowRates)
    }
}

final private class MockInteractor: ConversionsViewInteractorInput {
    var didCallFetchRates = false
    func fetchCurrentRates() {
        didCallFetchRates = true
    }
    
    var didCallStopUpdating = false
    func stopUpdatingRates() {
        didCallStopUpdating = true
    }
    
    var currentRates: [CurrencyRate] {
        return [CurrencyRate(code: "Code", rate: 1),
                CurrencyRate(code: "Another", rate: 2),
                CurrencyRate(code: "Another one", rate: 32),
                CurrencyRate(code: "One more", rate: 14)]
    }
    
    
}

final private class MockView: ConversionsViewInput {
    var didCallUpdateDatasource = false
    var updatedSource = [ConversionRateViewModel]()
    func updateDataSource(rates: [ConversionRateViewModel]) {
        updatedSource = rates
        didCallUpdateDatasource = true
    }
    
    var didCallShowNoResults = false
    func showNoResultsView() {
        didCallShowNoResults = true
    }
    
    var didCallShowLoading = false
    func showLoading() {
        didCallShowLoading = true
    }
    
    var didCallShowRates = false
    func show(rates: [ConversionRateViewModel]) {
        didCallShowRates = true
    }
    
}

final private class MockConverter: ConversionViewModelConverter {
    func convert(rates: [CurrencyRate], multiplier: Double, conversionDelegate: CurrencyValueChangeDelegate?, editingViewModel: ConversionRateViewModel?) -> [ConversionRateViewModel] {
        didCallConvert = true
        self.multiplier = multiplier
        return [ConversionRateViewModel(image: nil, rate: "1", code: "Code", name: "Name", conversionDelegate: nil)]

    }
    
    var multiplier: Double = 0
    var didCallConvert = false
    
}
