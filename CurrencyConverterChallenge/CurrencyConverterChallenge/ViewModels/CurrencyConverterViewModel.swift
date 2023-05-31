//
//  CurrencyConverterViewModel.swift
//  CurrencyConverterChallenge
//
//  Created by Ace Green on 2023-05-24.
//

import Foundation

// MARK: - CurrencyConverterViewModel

class CurrencyConverterViewModel: ObservableObject {

    private(set) var currencyConverter = CurrencyConverter.shared
    var currentTextFieldIdentifier: CurrencyConverterViewController.CurrencyTextFieldIdentifier = .fromCurrency
    var changeCurrencyTextFieldIdentifier: CurrencyConverterViewController.CurrencyTextFieldIdentifier = .fromCurrency

    @Published private(set) var originalAmount: Double = 0.0
    @Published private(set) var totalAmount: Double = 0.0
    @Published private(set) var exchangeRate: Double = 0.0
    @Published private(set) var exchangeAmount: Double = 0.0

    func calculateExchange(value: Double,
                           valueCurrency: Currency,
                           outputCurrency: Currency,
                           completion: @escaping () -> Void = {}) {

        currencyConverter.updateExchangeRates(completion: {
            guard let doubleResult = self.currencyConverter.convert(value,
                                                                    valueCurrency: valueCurrency,
                                                                    outputCurrency: outputCurrency) else { return }
            switch self.currentTextFieldIdentifier {
            case .fromCurrency:
                self.set(originalAmount: value)
                self.set(totalAmount: value)
                self.set(exchangeRate: self.calculateRate(valueCurrency: valueCurrency, outputCurrency: outputCurrency))
                self.set(exchangeAmount: doubleResult)
            case .toCurrency:
                self.set(originalAmount: doubleResult)
                self.set(totalAmount: doubleResult)
                self.set(exchangeRate: self.calculateRate(valueCurrency: outputCurrency, outputCurrency: valueCurrency))
                self.set(exchangeAmount: value)
            }
        })
    }

    func calculateRate(valueCurrency: Currency, outputCurrency: Currency) -> Double {
        guard let valueRate = currencyConverter.exchangeRates[valueCurrency] else { return 0.0 }
        guard let outputRate = currencyConverter.exchangeRates[outputCurrency] else { return 0.0 }
        let multiplier = outputRate/valueRate
        return multiplier
    }

    fileprivate func set(currencyConverter: CurrencyConverter) {
        self.currencyConverter = currencyConverter
    }

    fileprivate func set(originalAmount: Double) {
        self.originalAmount = originalAmount
    }

    fileprivate func set(totalAmount: Double) {
        self.totalAmount = totalAmount
    }

    fileprivate func set(exchangeRate: Double) {
        self.exchangeRate = exchangeRate
    }

    fileprivate func set(exchangeAmount: Double) {
        self.exchangeAmount = exchangeAmount
    }

    fileprivate func zeroOutAmounts() {
        set(originalAmount: 0)
        set(totalAmount: 0)
        set(exchangeAmount: 0)
        set(exchangeRate: 0)
    }
}

class MockCurrencyConverterViewModel: CurrencyConverterViewModel {
    override init() {
        super.init()
        self.set(currencyConverter: MockCurrencyConverter())
    }
}
