//
//  CountryPickerViewController.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/28/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

protocol CountryPickerViewControllerDelegate: class {
    func countryPickerViewController(_ viewController: CountryPickerViewController, didFinishWith country: Country)
}

class CountryPickerViewController: UIViewController {
    
    // MARK: - Types
    enum SearchState {
        case normal
        case searching
    }
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    weak var delegate: CountryPickerViewControllerDelegate?
    @objc lazy var cancelBarButtonItem: UIBarButtonItem = {
        let cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.didPressCancel(_:)))
        return cancelBarButtonItem
    }()
    
    @objc lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.tintColor = .app_orange
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        (UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]) ).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
        
        return searchController
    }()
    
    @objc let dataSource: [String] = {
        let codes = Locale.isoRegionCodes
        let names = codes.flatMap(Locale.current.localizedString(forRegionCode:)).sorted()
        return ["--"] + names
    }()
    
    @objc var selectedName = "--"
    @objc var searchString = ""
    @objc var shouldAnimateUpdate = true
    
    var searchState: SearchState {
        if searchController.isActive && !searchString.isEmpty
        {
            return .searching
        }
        return .normal
    }
    
    @objc var searchResults: [String]
    {
        
        guard searchState == .searching else { return [] }
        
        return dataSource.filter { $0.lowercased().contains(searchString.lowercased()) }
        
    }
    
    // MARK: - Lifecycle
    init(delegate: CountryPickerViewControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: "\(CountryPickerViewController.self)", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .app_orange
        
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        let nib = UINib(nibName: "\(CountryPickerTableViewCell.self)", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "\(CountryPickerTableViewCell.self)")
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        else {
            tableView.tableHeaderView = searchController.searchBar
        }
    }
    
    // MARK: - Actions
    @objc
    fileprivate func didPressCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    
    fileprivate func country(for name: String) -> Country? {
        guard let abbreviation = Locale.isoRegionCodes.first(where: { Locale.current.localizedString(forRegionCode: $0) == name }) else { return nil }
        return Country(abbreviation: abbreviation)
    }
}

// MARK: - UITableViewDataSource / UITableViewDelegate
extension CountryPickerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchState == .normal ? dataSource.count : searchResults.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(CountryPickerTableViewCell.self)", for: indexPath) as! CountryPickerTableViewCell
        let name: String
        switch searchState {
        case .normal:
            name = dataSource[indexPath.row]
            cell.name = name
        case .searching:
            name = searchResults[indexPath.row]
            cell.name = name
            cell.searchString = searchString
        }
        cell.accessoryType = selectedName == name ? .checkmark : .none
        cell.tintColor = UIColor.app_purple
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let name: String
        switch searchState {
        case .normal:
            name = dataSource[indexPath.row]
        case .searching:
            name = searchResults[indexPath.row]
        }
        guard let country = country(for: name) else { return }
        selectedName = name
        shouldAnimateUpdate = false
        tableView.reloadRows(at: [indexPath], with: .none)
        searchController.isActive = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.delegate?.countryPickerViewController(self, didFinishWith: country)
            self.dismiss(animated: true)
        }
    }
}

// MARK:- UISearchResultsUpdating
extension CountryPickerViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        let oldValue = searchResults.isEmpty && searchString.isEmpty ? dataSource : searchResults
        searchString = text
        let newValue = searchResults.isEmpty && searchString.isEmpty ? dataSource : searchResults
        if shouldAnimateUpdate {
            tableView.animateUpdate(oldDataSource: oldValue, newDataSource: newValue)
        } else {
            tableView.reloadData()
        }
    }
}

