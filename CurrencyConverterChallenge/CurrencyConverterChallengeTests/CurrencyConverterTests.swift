//
//  CurrencyConverterTests.swift
//  CurrencyConverterChallengeTests
//
//  Created by Ace Green on 2023-05-24.
//

import XCTest
@testable import CurrencyConverterChallenge

// MARK: - CurrencyConverterTests

final class CurrencyConverterTests: XCTestCase {

    var mockCurrencyConverter: MockCurrencyConverter?

    override func setUp() {
        super.setUp()
        mockCurrencyConverter = MockCurrencyConverter()
    }

    func testConversionJPYToUSD() throws {
        guard let mockCurrencyConverter = mockCurrencyConverter else { return }
        guard let result = mockCurrencyConverter.convert(14100000,
                                                         valueCurrency: .JPY,
                                                         outputCurrency: .USD) else { return }

        XCTAssert(result == 125927.81634585043)
    }

    func testConversionUSDToJPY() throws {
        guard let mockCurrencyConverter = mockCurrencyConverter else { return }
        guard let result = mockCurrencyConverter.convert(100000,
                                                         valueCurrency: .USD,
                                                         outputCurrency: .JPY) else { return }

        XCTAssert(result == 11196890.734034095)
    }

    override func tearDown() {
        mockCurrencyConverter = nil
        super.tearDown()
    }
}
