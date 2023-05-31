//
//  String+Extensions.swift
//  CurrencyConverterChallenge
//
//  Created by Ace Green on 2023-05-24.
//

import Foundation

extension String {

    /**
     Returns a formatted double from a from string value.
     Usage example: format("1000")
     */
    static func format(_ value: String) -> Double? {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        return formatter.number(from: value.replacingOccurrences(of: ",",
                                                                 with: "",
                                                                 options: NSString.CompareOptions.literal,
                                                                 range: nil))?.doubleValue
    }
}
