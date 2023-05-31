//
//  Double+Extensions.swift
//  CurrencyConverterChallenge
//
//  Created by Ace Green on 2023-05-24.
//

import Foundation

extension Double {

    /**
     Returns a formatted string from a double value.
     Usage example: format(1000, numberStyle: .currency, decimalPlaces: 2)
     */
    static func format(_ value: Double, numberStyle: NumberFormatter.Style, decimalPlaces: Int) -> String? {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = numberStyle
        formatter.maximumFractionDigits = decimalPlaces
        return formatter.string(from: NSNumber(value: value))
    }

    /**
     Returns a rounded double value to decimal places.
     Usage example: round((to: 2)
     */
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
