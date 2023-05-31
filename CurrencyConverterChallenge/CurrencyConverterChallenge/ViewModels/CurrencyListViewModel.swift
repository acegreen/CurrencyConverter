//
//  CurrencyListViewModel.swift
//  CurrencyConverterChallenge
//
//  Created by Ace Green on 2023-05-24.
//

import Foundation

// MARK: - CurrencyListViewModel

class CurrencyListViewModel: ObservableObject {

    private(set) var currencies: [Currency] = Currency.allCases
    @Published private(set) var filteredData: [Currency] = Currency.allCases

    fileprivate func set(filteredData: [Currency]) {
        self.filteredData = filteredData
    }

    func flag(for currency: Currency) -> String? {
        return Currency.flagsByCurrencies[currency]
    }

    func filterSearch(searchText: String) {
        let filteredData = searchText.isEmpty ? currencies: currencies.filter({(currency: Currency) -> Bool in
            let currencyRawValue = currency.rawValue.range(of: searchText, options: .caseInsensitive)
            let currencyDescription = currency.description.range(of: searchText, options: .caseInsensitive)
            return (currencyRawValue != nil) || (currencyDescription != nil)
        })
        set(filteredData: filteredData)
    }
}

class MockCurrencyListViewModel: CurrencyListViewModel { }
