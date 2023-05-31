//
//  CurrencyListTableViewController.swift
//  CurrencyConverterChallenge
//
//  Created by Ace Green on 2023-05-24.
//

import UIKit
import Combine

// MARK: - CurrencyListTableViewDelegate

protocol CurrencyListTableViewDelegate: AnyObject {
    func didSelect(currency: Currency)
}

// MARK: - CurrencyListTableViewController

class CurrencyListTableViewController: UITableViewController, UISearchBarDelegate {

    // MARK: - IBOutlets

    @IBOutlet weak var searchBar: UISearchBar!

    // MARK: - Delegate

    var delegate: CurrencyListTableViewDelegate?

    // MARK: - Properties

    private var viewModel: CurrencyListViewModel = CurrencyListViewModel()
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Lifecylce methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBinding()
        configureDelegates()
    }

    private func configureBinding() {

        viewModel.$filteredData
            .sink { [weak self] _ in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            .store(in: &subscriptions)
    }

    private func configureDelegates() {
        tableView.dataSource = self
        searchBar.delegate = self
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyListTableCell",
                                                       for: indexPath) as? CurrencyListTableViewCell else { return UITableViewCell() }
        cell.currencyImage.image = viewModel.flag(for: viewModel.filteredData[indexPath.row])?.toImage(fontSize: 40)
        cell.currencyCodeLabel.text = viewModel.filteredData[indexPath.row].rawValue
        cell.currencyNameLabel.text = viewModel.filteredData[indexPath.row].description
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currencyAtIndex =  Currency(rawValue: viewModel.filteredData[indexPath.row].rawValue) else { return }
        delegate?.didSelect(currency: currencyAtIndex)
        self.dismiss(animated: true)
    }

    // MARK: - UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterSearch(searchText: searchText)
    }
}
