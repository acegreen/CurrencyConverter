//
//  CurrencyListViewModelTests.swift
//  CurrencyConverterChallengeTests
//
//  Created by Ace Green on 2023-05-30.
//

import XCTest
@testable import CurrencyConverterChallenge

final class CurrencyListViewModelTests: XCTestCase {

    var mockCurrencyConverter: MockCurrencyConverter?
    var mockViewModel: MockCurrencyListViewModel?

    override func setUp() {
        super.setUp()
        mockCurrencyConverter = MockCurrencyConverter()
        mockViewModel = MockCurrencyListViewModel()
    }

    func testCurrencyListViewModelFlag() throws {
        guard let mockViewModel = mockViewModel else { return }
        let flag = mockViewModel.flag(for: .JPY)
        XCTAssert(flag == "🇯🇵")
    }

    func testCurrencyListViewModelFilterSearch() throws {
        guard let mockViewModel = mockViewModel else { return }
        mockViewModel.filterSearch(searchText: "JPY")
        let japaneseCurrency = Currency(rawValue: "JPY")
        XCTAssert(mockViewModel.filteredData == [japaneseCurrency])
    }

    override func tearDown() {
        mockCurrencyConverter = nil
        mockViewModel = nil
        super.tearDown()
    }
}
