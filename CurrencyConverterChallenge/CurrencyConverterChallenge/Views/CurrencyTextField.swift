//
//  CurrencyTextField.swift
//  CurrencyConverterChallenge
//
//  Created by Ace Green on 2023-05-24.
//

import UIKit

// MARK: - CurrencyTextFieldDelegate

protocol CurrencyTextFieldDelegate: StyledTextFieldDelegate {
    func textFieldImageSelected(textFieldIdentifier: CurrencyConverterViewController.CurrencyTextFieldIdentifier)
}

class CurrencyTextField: StyledTextField {

    // MARK: - Delegates

    private var currencyTextFieldDelegate: CurrencyTextFieldDelegate? {
        return styledTextFieldDelegate as? CurrencyTextFieldDelegate
    }

    // MARK: - Properties

    private(set) var currency: Currency = .JPY
    var textFieldIdentifier: CurrencyConverterViewController.CurrencyTextFieldIdentifier = .fromCurrency

    // MARK: - Methods

    func configure(currency: Currency, textFieldIdentifier: CurrencyConverterViewController.CurrencyTextFieldIdentifier) {
        self.currency = currency
        self.image = Currency.nameWithFlag(for: currency).toImage()
        self.textFieldIdentifier = textFieldIdentifier
    }

    override func textFieldImageSelected(button: UIButton) {
        self.currencyTextFieldDelegate?.textFieldImageSelected(textFieldIdentifier: textFieldIdentifier)
    }
}
