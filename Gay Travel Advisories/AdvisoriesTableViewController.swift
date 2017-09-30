//
//  AdvisoriesTableViewController.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/28/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

// MARK: - AdvisoriesTableViewController
class AdvisoriesTableViewController: UITableViewController {

    // MARK: - Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Setup
    private func setupUI() {
        
        title = "Advisories"
        view.backgroundColor = .app_black
        clearsSelectionOnViewWillAppear = true
        
        tableView.rowHeight = 44.0
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.tintColor = UIColor.app_orange
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        }
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let region = CountriesManager.shared.regions?[indexPath.section]
        guard let country = region?.countries[indexPath.row] else { return }
        let advisoryDetailViewController = AdvisoryDetailViewController(country: country)
        if tabBarController?.splitViewController != nil && tabBarController?.splitViewController?.traitCollection.isLargerDevice == true {
            tableView.deselectRow(at: indexPath, animated: true)
            let navigationController = UINavigationController(rootViewController: advisoryDetailViewController)
            tabBarController?.splitViewController?.showDetailViewController(navigationController, sender: nil)
        }
        else {
            navigationController?.pushViewController(advisoryDetailViewController, animated: true)
        }
    }
}

extension AdvisoriesTableViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location),
              let region = CountriesManager.shared.regions?[indexPath.section],
              let cell = tableView.cellForRow(at: indexPath) else { return nil }
        let rect = view.convert(cell.bounds, from: cell)
        previewingContext.sourceRect = rect
        let country = region.countries[indexPath.row]
        let advisoryDetailViewController = AdvisoryDetailViewController(country: country)
        return advisoryDetailViewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}
