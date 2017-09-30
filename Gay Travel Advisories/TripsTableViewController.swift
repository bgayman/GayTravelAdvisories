//
//  TripsTableViewController.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/28/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

// MARK: - TripsTableViewController
class TripsTableViewController: UITableViewController {

    @objc lazy var addBarButtonItem: UIBarButtonItem = {
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.didPressAdd(_:)))
        return addBarButtonItem
    }()
    
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
        
        title = "Trips"
        view.backgroundColor = .app_black
        
        tabBarController?.tabBar.barTintColor = UIColor.black
        tabBarController?.tabBar.tintColor = UIColor.app_orange
        
        navigationItem.rightBarButtonItem = addBarButtonItem
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.tintColor = UIColor.app_orange
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        }
    }
    
    private func setupNotifications() {
        NotificationCenter.default.when(.CountriesManagerDidUpdate) { [weak self] (_) in
            self?.tableView.reloadData()
        }
    }
    
    @objc
    private func didPressAdd(_ sender: UIBarButtonItem) {
        let addTripViewController = AddTripViewController(delegate: self)
        let navigationController = UINavigationController(rootViewController: addTripViewController)
        navigationController.modalPresentationStyle = .overCurrentContext
        self.tabBarController?.present(navigationController, animated: true)
    }
    
    @objc
    private func didPressTravelAdvisory(_ sender: UIButton) {
        let location = view.convert(sender.bounds.origin, from: sender)
        guard let indexPath = tableView.indexPathForRow(at: location),
              let cell = tableView.cellForRow(at: indexPath) as? TripTableViewCell,
              let trip = cell.trip else { return  }
        let advisoryDetailViewController = AdvisoryDetailViewController(country: trip.country)
        if tabBarController?.splitViewController != nil {
           
            let navigationController = UINavigationController(rootViewController: advisoryDetailViewController)
            tabBarController?.splitViewController?.showDetailViewController(navigationController, sender: nil)
        }
        else {
            navigationController?.pushViewController(advisoryDetailViewController, animated: true)
        }
        
    }

    // MARK: - UITableViewDataSource / UITableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TripManager.shared.trips.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TripTableViewCell
        let trip = TripManager.shared.trips[indexPath.row]
        cell.trip = trip
        cell.travelAdvisoryButton.addTarget(self, action: #selector(self.didPressTravelAdvisory(_:)), for: .touchUpInside)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (_, indexPath) in
            let trip = TripManager.shared.trips[indexPath.row]
            TripManager.shared.remove(trip)
            self?.tableView.deleteRows(at: [indexPath], with: .left)
            
        }
        return [delete]
    }

}

extension TripsTableViewController: AddTripViewControllerDelegate {
    func addTripViewController(_ viewController: AddTripViewController, didFinishWith trip: Trip) {
        let oldValue = TripManager.shared.trips
        TripManager.shared.add(trip)
        tableView.animateUpdate(oldDataSource: oldValue, newDataSource: TripManager.shared.trips)
    }
}
