//
//  CurrencyTests.swift
//  CurrencyConverterChallengeTests
//
//  Created by Ace Green on 2023-05-31.
//

import XCTest
@testable import CurrencyConverterChallenge

// MARK: - CurrencyTests

final class CurrencyTests: XCTestCase {

    var mockCurrency: Currency?

    override func setUp() {
        super.setUp()
        mockCurrency = Currency(rawValue: "JPY")
    }

    func testCurrencyDescription() throws {
        guard let mockCurrency = mockCurrency else { return }
        XCTAssert(mockCurrency.description == "Japanese Yen")
    }

    func testCurrencyFlagsByCurrencies() throws {
        guard let mockCurrency = mockCurrency else { return }
        let flag = Currency.flagsByCurrencies[mockCurrency]
        XCTAssert(flag == "🇯🇵")
    }

    func testCurrencyNameWithFlag() throws {
        guard let mockCurrency = mockCurrency, let flag = Currency.flagsByCurrencies[mockCurrency] else { return }
        let nameWithFlag = flag + " " + mockCurrency.rawValue
        XCTAssert(nameWithFlag == Currency.nameWithFlag(for: .JPY))
    }

    override func tearDown() {
        mockCurrency = nil
        super.tearDown()
    }
}
