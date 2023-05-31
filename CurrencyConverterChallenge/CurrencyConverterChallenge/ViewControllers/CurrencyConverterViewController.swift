//
//  CurrencyConverterViewController.swift
//  CurrencyConverterChallenge
//
//  Created by Ace Green on 2023-05-24.
//

import UIKit
import Combine
import SkeletonView

// MARK: - CurrencyConverterViewController

class CurrencyConverterViewController: UIViewController, UITextFieldDelegate {

    // MARK: - IBOutlets

    @IBOutlet weak var fromCurrencyTextField: CurrencyTextField!
    @IBOutlet weak var toCurrencyTextField: CurrencyTextField!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var skeletonStackView: UIStackView!

    // MARK: - Properties

    enum CurrencyTextFieldIdentifier: Int {
        case fromCurrency = 0
        case toCurrency = 1
    }

    enum SegueIdentifier: String {
        case showCurrenciesList = "currenciesListSegueIdentifier"
    }

    private var viewModel: CurrencyConverterViewModel = CurrencyConverterViewModel()
    private var subscriptions = Set<AnyCancellable>()
    private var textFieldTimer: Timer?
    let timerDelay = 3.0

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureBinding()
        configureDelegates()
        configureGestures()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fromCurrencyTextField.text = nil
        toCurrencyTextField.text = nil
    }

    deinit {
        textFieldTimer?.invalidate()
    }

    // MARK: - Methods

    private func configureViews() {
        fromCurrencyTextField.configure(currency: .JPY, textFieldIdentifier: .fromCurrency)
        toCurrencyTextField.configure(currency: .USD, textFieldIdentifier: .toCurrency)
    }

    private func configureBinding() {

        viewModel.$originalAmount
            .sink { [weak self] originalAmount in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    guard let doubleFormattedNewValue = Double.format(originalAmount,
                                                                      numberStyle: .decimal,
                                                                      decimalPlaces: 2) else { return }
                    self.fromCurrencyTextField.text = doubleFormattedNewValue
                }
            }
            .store(in: &subscriptions)

        viewModel.$totalAmount
            .sink { [weak self] totalAmount in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    guard let doubleFormattedNewValue = Double.format(totalAmount,
                                                                      numberStyle: .decimal,
                                                                      decimalPlaces: 2) else { return }
                    self.skeletonStackView.hideSkeleton()
                    self.totalAmountLabel.text = doubleFormattedNewValue + " " + self.fromCurrencyTextField.currency.rawValue
                }
            }
            .store(in: &subscriptions)

        viewModel.$exchangeRate
            .sink { [weak self] exchangeRate in
                guard let self = self, let doubleFormattedValue = Double.format(exchangeRate, numberStyle: .decimal, decimalPlaces: 6) else { return }
                DispatchQueue.main.async {
                    self.skeletonStackView.hideSkeleton()
                    self.rateLabel.text = doubleFormattedValue
                }
            }
            .store(in: &subscriptions)

        viewModel.$exchangeAmount
            .sink { [weak self] exchangeAmount in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    guard let doubleFormattedNewValue = Double.format(exchangeAmount, numberStyle: .decimal, decimalPlaces: 2) else { return }
                    self.toCurrencyTextField.text = doubleFormattedNewValue
                }
            }
            .store(in: &subscriptions)
    }

    private func configureDelegates() {
        fromCurrencyTextField.delegate = self
        toCurrencyTextField.delegate = self
    }

    private func configureGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        view.addGestureRecognizer(tapGesture)
    }

    // MARK: - IBActions

    @IBAction func textFieldEditingChanged(_ sender: CurrencyTextField) {
        self.viewModel.currentTextFieldIdentifier = sender.textFieldIdentifier
        guard let text = sender.text else { return }

        skeletonStackView.showAnimatedGradientSkeleton()
        if textFieldTimer != nil {
            textFieldTimer?.invalidate()
            textFieldTimer = nil
        }

        textFieldTimer = Timer.scheduledTimer(timeInterval: timerDelay, target: self, selector: #selector(textChanged(_:)),
                                              userInfo: text,
                                              repeats: false)
    }

    @objc func textChanged(_ timer: Timer) {
        guard let text = timer.userInfo as? String, let value = String.format(text) else {
            skeletonStackView.showAnimatedGradientSkeleton()
            fromCurrencyTextField.text = nil
            toCurrencyTextField.text = nil
            return
        }
        switch self.viewModel.currentTextFieldIdentifier {
        case .fromCurrency:
            viewModel.calculateExchange(value: value,
                                        valueCurrency: self.fromCurrencyTextField.currency,
                                        outputCurrency: self.toCurrencyTextField.currency)
        case .toCurrency:
            viewModel.calculateExchange(value: value,
                                        valueCurrency: self.toCurrencyTextField.currency,
                                        outputCurrency: self.fromCurrencyTextField.currency)
        }
    }

    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        fromCurrencyTextField.resignFirstResponder()
        toCurrencyTextField.resignFirstResponder()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationController = segue.destination as? UINavigationController,
           let rootViewController = destinationController.topViewController as? CurrencyListTableViewController {
            rootViewController.delegate = self
        }
    }
}

// MARK: - StyledTextFieldDelegate

extension CurrencyConverterViewController: StyledTextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text,
              let range = Range(range, in: oldText),
              let decimalSeparator = Locale.current.decimalSeparator else { return true }
        let newText = oldText.replacingCharacters(in: range, with: string)
        let isNumeric = newText.isEmpty || (String.format(newText) != nil)
        let numberOfDots = newText.components(separatedBy: decimalSeparator).count - 1

        let numberOfDecimalDigits: Int
        if let dotIndex = newText.firstIndex(of: Character(decimalSeparator)) {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }

        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let textField = textField as? StyledTextField else { return true }
        textField.setActive()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let textField = textField as? StyledTextField else { return }
        textField.setInActive()
    }

    func textFieldImageSelected() { }
}

extension CurrencyConverterViewController: CurrencyTextFieldDelegate {

    func textFieldImageSelected(textFieldIdentifier: CurrencyTextFieldIdentifier) {
        viewModel.changeCurrencyTextFieldIdentifier = textFieldIdentifier
        performSegue(withIdentifier: SegueIdentifier.showCurrenciesList.rawValue, sender: nil)
    }
}

// MARK: - CurrencyListTableViewDelegate

extension CurrencyConverterViewController: CurrencyListTableViewDelegate {
    func didSelect(currency: Currency) {
        switch viewModel.changeCurrencyTextFieldIdentifier {
        case .fromCurrency:
            fromCurrencyTextField.configure(currency: currency, textFieldIdentifier: .fromCurrency)
        case .toCurrency:
            toCurrencyTextField.configure(currency: currency, textFieldIdentifier: .toCurrency)
        }

        switch self.viewModel.currentTextFieldIdentifier {
        case .fromCurrency:
            viewModel.calculateExchange(value: viewModel.originalAmount,
                                        valueCurrency: self.fromCurrencyTextField.currency,
                                        outputCurrency: self.toCurrencyTextField.currency)
        case .toCurrency:
            viewModel.calculateExchange(value: viewModel.exchangeAmount,
                                        valueCurrency: self.toCurrencyTextField.currency,
                                        outputCurrency: self.fromCurrencyTextField.currency)
        }
    }
}
