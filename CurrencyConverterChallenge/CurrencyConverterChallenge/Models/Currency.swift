//
//  Currency.swift
//  CurrencyConverterChallenge
//
//  Created by Ace Green on 2023-05-24.
//

import Foundation

// MARK: - Currency

enum Currency: String, CaseIterable, CustomStringConvertible {

    case AUD; case BGN
    case BRL; case CAD
    case CHF; case CNY
    case CZK; case DKK
    case EUR; case GBP
    case HKD; case HUF
    case IDR; case ILS
    case INR; case ISK
    case JPY; case KRW
    case MXN; case MYR
    case NOK; case NZD
    case PHP; case PLN
    case RON; case RUB
    case SEK; case SGD
    case THB; case TRY
    case USD; case ZAR

    /** Returns flag of currency.  */
    static let flagsByCurrencies: [Currency: String] = [
        .AUD: "🇦🇺", .BGN: "🇧🇬",
        .BRL: "🇧🇷", .CAD: "🇨🇦",
        .CHF: "🇨🇭", .CNY: "🇨🇳",
        .CZK: "🇨🇿", .DKK: "🇩🇰",
        .EUR: "🇪🇺", .GBP: "🇬🇧",
        .HKD: "🇭🇰", .HUF: "🇭🇺",
        .IDR: "🇮🇩", .ILS: "🇮🇱",
        .INR: "🇮🇳", .ISK: "🇮🇸",
        .JPY: "🇯🇵", .KRW: "🇰🇷",
        .MXN: "🇲🇽", .MYR: "🇲🇾",
        .NOK: "🇳🇴", .NZD: "🇳🇿",
        .PHP: "🇵🇭", .PLN: "🇵🇱",
        .RON: "🇷🇴", .RUB: "🇷🇺",
        .SEK: "🇸🇪", .SGD: "🇸🇬",
        .THB: "🇹🇭", .TRY: "🇹🇷",
        .USD: "🇺🇸", .ZAR: "🇿🇦"

    ]

    /** Returns a currency name with it's flag (🇯🇵 JPY, for example). */
    static func nameWithFlag(for currency: Currency) -> String {
        return (Currency.flagsByCurrencies[currency] ?? "?") + " " + currency.rawValue
    }

    /** Returns description of currency in long form. */
    var description: String {
        switch self {
        case .AUD:
            return "Australian Dollar"
        case .BGN:
            return "Brazilian Real"
        case .BRL:
            return "Bulgarian Lev"
        case .CAD:
            return "Canadian Dollar"
        case .CHF:
            return "Swiss Franc"
        case .CNY:
            return "Chinese Yuan"
        case .CZK:
            return "Czech Koruna"
        case .DKK:
            return "Danish Krone"
        case .EUR:
            return "Euro"
        case .GBP:
            return "British Pound"
        case .HKD:
            return "Hong Kong Dollar"
        case .HUF:
            return "Hungarian Forint"
        case .IDR:
            return "Indonesian Rupiah"
        case .ILS:
            return "Israeli Shekel"
        case .INR:
            return "Indian Rupee"
        case .ISK:
            return "Icelandic Króna"
        case .JPY:
            return "Japanese Yen"
        case .KRW:
            return "South Korean Won"
        case .MXN:
            return "Mexican Peso"
        case .MYR:
            return "Malaysian Ringgit"
        case .NOK:
            return "Norwegian Krone"
        case .NZD:
            return "New Zealand Dollar"
        case .PHP:
            return "Philippine Peso"
        case .PLN:
            return "Polish Zloty"
        case .RON:
            return "New Romanian Leu"
        case .RUB:
            return "Russian Rouble"
        case .SEK:
            return "Swedish Krona"
        case .SGD:
            return "Singapore Dollar"
        case .THB:
            return "Thai Baht"
        case .TRY:
            return "Turkish Lira"
        case .USD:
            return "US Dollar"
        case .ZAR:
            return "South African Rand"
        }
    }
}
