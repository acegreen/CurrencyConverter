//
//  CurrencyConverterViewModelTests.swift
//  CurrencyConverterChallengeTests
//
//  Created by Ace Green on 2023-05-30.
//

import XCTest
@testable import CurrencyConverterChallenge

final class CurrencyConverterViewModelTests: XCTestCase {

    var mockCurrencyConverter: MockCurrencyConverter?
    var mockViewModel: MockCurrencyConverterViewModel?

    override func setUp() {
        super.setUp()
        mockCurrencyConverter = MockCurrencyConverter()
        mockViewModel = MockCurrencyConverterViewModel()
    }

    func testCurrencyConverterViewModelCalculateExchange() throws {
        guard let mockViewModel = mockViewModel else { return }
        mockViewModel.calculateExchange(value: 14100000,
                                    valueCurrency: .JPY,
                                    outputCurrency: .USD) {
            XCTAssert(mockViewModel.originalAmount == 14100000)
            XCTAssert(mockViewModel.totalAmount == 14100000)
            XCTAssert(mockViewModel.exchangeRate == 0.008931050804670243)
            XCTAssert(mockViewModel.exchangeAmount == 125927.81634585043)
        }
    }

    func testCurrencyConverterViewModelCalculateRate() throws {
        guard let mockViewModel = mockViewModel else { return }
        let multiplier = mockViewModel.calculateRate(valueCurrency: .JPY, outputCurrency: .USD)
        XCTAssert(multiplier == 0.008931050804670243)
    }

    override func tearDown() {
        mockCurrencyConverter = nil
        mockViewModel = nil
        super.tearDown()
    }
}
