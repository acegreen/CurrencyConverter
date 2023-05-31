//
//  CurrencyConverter.swift
//  CurrencyConverterChallenge
//
//  Created by Ace Green on 2023-05-24.
//

import Foundation

// MARK: - CurrencyConverter

class CurrencyConverter {

    static let shared = CurrencyConverter()

    var exchangeRates: [Currency: Double] = [:]
    private let xmlParser = CurrencyXMLParser()

    init() { updateExchangeRates {} }

    /** Updates the exchange rate and runs the completion afterwards. */
    public func updateExchangeRates(completion: @escaping () -> Void = {}) {
        xmlParser.parse(completion: {
            self.exchangeRates = self.xmlParser.getExchangeRates()
            CurrencyConverterLocalData.saveLocalExchangeRates(self.exchangeRates)
            completion()
        }, errorCompletion: { // No internet access/network error:
            self.exchangeRates = CurrencyConverterLocalData.loadLocalExchangeRates()
            completion()
        })
    }

    /**
     Converts a Double value based on it's currency (valueCurrency) and the output currency (outputCurrency).
     USD to JPY conversion example: convert(1000, valueCurrency: .USD, outputCurrency: .JPY)
     */
    public func convert(_ value: Double, valueCurrency: Currency, outputCurrency: Currency) -> Double? {
        guard let valueRate = exchangeRates[valueCurrency] else { return nil }
        guard let outputRate = exchangeRates[outputCurrency] else { return nil }
        let multiplier = outputRate/valueRate
        return value * multiplier
    }

    /**
     Converts a Double value based on it's currency and the output currency, and returns a formatted String.
     Usage example: convertAndFormat(1000, valueCurrency: .USD, outputCurrency: .JPY, numberStyle: .currency, decimalPlaces: 2)
     */
    public func convertAndFormat(_ value: Double,
                                 valueCurrency: Currency,
                                 outputCurrency: Currency,
                                 numberStyle: NumberFormatter.Style,
                                 decimalPlaces: Int) -> String? {
        guard let doubleOutput = convert(value, valueCurrency: valueCurrency, outputCurrency: outputCurrency) else {
            return nil
        }
        return Double.format(doubleOutput, numberStyle: numberStyle, decimalPlaces: decimalPlaces)
    }
}

private class CurrencyXMLParser: NSObject, XMLParserDelegate {

    private let xmlURL = "https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml"
    private var exchangeRates: [Currency: Double] = [
        .EUR: 1.0 // Base currency
    ]

    public func getExchangeRates() -> [Currency: Double] {
        return exchangeRates
    }

    public func parse(completion: @escaping () -> Void, errorCompletion: @escaping () -> Void) {
        guard let url = URL(string: xmlURL) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                errorCompletion()
                return
            }
            let parser = XMLParser(data: data)
            parser.delegate = self
            if parser.parse() {
                completion()
            } else {
                errorCompletion()
            }
        }
        task.resume()
    }

    // MARK: - XMLParserDelegate

    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String: String] = [:]) {
        if elementName == "Cube" {
            guard let currency = attributeDict["currency"] else { return }
            guard let rate = attributeDict["rate"] else { return }
            guard let exchangeRate = makeExchangeRate(currency: currency, rate: rate) else { return }
            exchangeRates.updateValue(exchangeRate.rate, forKey: exchangeRate.currency)
        }
    }

    private func makeExchangeRate(currency: String, rate: String) -> (currency: Currency, rate: Double)? {
        guard let currency = Currency(rawValue: currency) else { return nil }
        guard let rate = Double(rate) else { return nil }
        return (currency, rate)
    }

}

internal class CurrencyConverterLocalData {

    struct Keys {
        static let localDataExchangeRates = "CurrencyConverterLocalData.Keys.localDataExchangeRates"
    }

    /** Fallback rates, in case the user doesn't have internet access the first time running the app. */
    static let fallBackExchangeRates: [Currency: Double] = [
        .USD: 1.1321,
        .JPY: 126.76,
        .BGN: 1.9558,
        .CZK: 25.623,
        .DKK: 7.4643,
        .GBP: 0.86290,
        .HUF: 321.90,
        .PLN: 4.2796,
        .RON: 4.7598,
        .SEK: 10.4788,
        .CHF: 1.1326,
        .ISK: 135.20,
        .NOK: 9.6020,
        .RUB: 72.6133,
        .TRY: 6.5350,
        .AUD: 1.5771,
        .BRL: 4.3884,
        .CAD: 1.5082,
        .CNY: 7.5939,
        .HKD: 8.8788,
        .IDR: 15954.12,
        .ILS: 4.0389,
        .INR: 78.2915,
        .KRW: 1283.00,
        .MXN: 21.2360,
        .MYR: 4.6580,
        .NZD: 1.6748,
        .PHP: 58.553,
        .SGD: 1.5318,
        .THB: 35.955,
        .ZAR: 15.7631
    ]

    /** Saves the most recent exchange rates by locally storing it. */
    static func saveLocalExchangeRates(_ exchangeRates: [Currency: Double]) {
        let convertedExchangeRates = convertExchangeRatesForUserDefaults(exchangeRates)
        UserDefaults.standard.set(convertedExchangeRates, forKey: Keys.localDataExchangeRates)
    }

    /** Loads the most recent exchange rates from the local storage. */
    static func loadLocalExchangeRates() -> [Currency: Double] {
        if let userDefaultsExchangeRates = UserDefaults.standard.dictionary(forKey: Keys.localDataExchangeRates) as? [String: Double] {
            return convertExchangeRatesFromUserDefaults(userDefaultsExchangeRates)
    } else {
            return fallBackExchangeRates
        }
    }

    /** Converts the [String: Double] dictionary with the exchange rates to a [Currency: Double] dictionary. */
    private static func convertExchangeRatesFromUserDefaults(_ userDefaultsExchangeRates: [String: Double]) -> [Currency: Double] {
        var exchangeRates: [Currency: Double] = [:]
        for userDefaultExchangeRate in userDefaultsExchangeRates {
            if let currency = Currency(rawValue: userDefaultExchangeRate.key) {
                exchangeRates.updateValue(userDefaultExchangeRate.value, forKey: currency)
            }
        }
        return exchangeRates
    }

    /**
     Converts the [Currency: Double] dictionary with the exchange rates to a [String: Double] one so it can be stored locally.
     */
    private static func convertExchangeRatesForUserDefaults(_ exchangeRates: [Currency: Double]) -> [String: Double] {
        var userDefaultsExchangeRates: [String: Double] = [:]
        for exchangeRate in exchangeRates {
            userDefaultsExchangeRates.updateValue(exchangeRate.value, forKey: exchangeRate.key.rawValue)
        }
        return userDefaultsExchangeRates
    }
}

class MockCurrencyConverter: CurrencyConverter {

    override func updateExchangeRates(completion: @escaping () -> Void = {}) {
        self.exchangeRates = CurrencyConverterLocalData.fallBackExchangeRates
    }
}
