//
//  AdvisoriesTableViewController.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/28/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

class AdvisoriesTableViewController: UITableViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupUI() {
        
        title = "Advisories"
        view.backgroundColor = .app_black
        
        tableView.rowHeight = 44.0
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.tintColor = UIColor.app_orange
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
            navigationController?.navigationBar.largeTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        }
    }
    
    private func setupNotifications() {
        NotificationCenter.default.when(.CountriesManagerDidUpdate) { [weak self] (_) in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDataSource / UITableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return CountriesManager.shared.regions?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let region = CountriesManager.shared.regions?[section]
        return region?.countries.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let region = CountriesManager.shared.regions?[indexPath.section]
        let country = region?.countries[indexPath.row]
        cell.textLabel?.text = country?.displayName
        cell.textLabel?.textColor = .white
        cell.contentView.backgroundColor = .clear
        cell.backgroundView?.backgroundColor = .clear
        cell.backgroundColor = .clear
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let region = CountriesManager.shared.regions?[section]
        return region?.name
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let view = view as? UITableViewHeaderFooterView else { return }
        view.backgroundView?.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        view.textLabel?.textColor = UIColor.app_purple
    }
}
