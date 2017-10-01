//
//  TripsTableViewController.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/28/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit
import MobileCoreServices

// MARK: - TripsTableViewController
final class TripsTableViewController: UITableViewController, PoorConnectionShowable, ErrorHandleable {

    // MARK: - Types
    enum DropView {
        case tabBar
        case navigationBar
        
        init?(view: UIView?) {
            if view is UINavigationBar == true {
                self = .navigationBar
            }
            else if view is UITabBar == true {
                self = .tabBar
            }
            else {
                
                return nil
            }
        }
    }
    
    // MARK: - Properties
    @objc lazy var addBarButtonItem: UIBarButtonItem = {
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.didPressAdd(_: )))
        
        return addBarButtonItem
    }()
    
    @objc lazy var refresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.didRefresh(_: )), for: .valueChanged)
        
        return refresh
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if navigationController?.poorConnectionView != nil {
            navigationController?.poorConnectionView?.removeFromSuperview()
            navigationController?.showPoorConnectionView()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup
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
            tableView.dragDelegate = self
            tableView.dragInteractionEnabled = true
            navigationController?.navigationBar.addInteraction(UIDropInteraction(delegate: self))
            tabBarController?.tabBar.addInteraction(UIDropInteraction(delegate: self))
        }
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
        
        refreshControl = refresh
    }
    
    private func setupNotifications() {
        NotificationCenter.default.when(.countriesManagerDidUpdate) { [weak self] (_) in
            self?.tableView.reloadData()
        }
        
        NotificationCenter.default.when(.webserviceDidFailToConnect) { [weak self] (_) in
            self?.showPoorConnection()
        }
        
        NotificationCenter.default.when(.webserviceDidConnect) { [weak self] (_) in
            self?.hidePoorConnection()
        }
    }
    
    // MARK: - Actions
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
        showAdvisory(for: trip.country)
    }
    
    @objc
    private func didRefresh(_ sender: UIRefreshControl) {
        CountriesManager.shared.getAdvisoryRegions { (result) in
            sender.endRefreshing()
            switch result {
            case .error(let error):
                self.handle(error)
            case .success:
                break
            }
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
        cell.travelAdvisoryButton.addTarget(self, action: #selector(self.didPressTravelAdvisory(_: )), for: .touchUpInside)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { [unowned self] (_, indexPath) in
            let trip = TripManager.shared.trips[indexPath.row]
            TripManager.shared.remove(trip)
            self.tableView.deleteRows(at: [indexPath], with: .left)
            
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { [unowned self] (_, indexPath) in
            let trip = TripManager.shared.trips[indexPath.row]
            self.showEdit(for: trip)
        }
        
        edit.backgroundColor = UIColor.app_orange
        
        return [delete, edit]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TripTableViewCell else { return }
        
        // Selection isn't possible in cells but tapping advisory button is
        // so bounce button to indicate 
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
        
        cell.travelAdvisoryButton.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: [], animations: {
            cell.travelAdvisoryButton.transform = .identity
        })
    }
    
    // MARK: - Helpers
    fileprivate func showEdit(for trip: Trip) {
        let addTripViewController = AddTripViewController(delegate: self, editTrip: trip)
        let navigationController = UINavigationController(rootViewController: addTripViewController)
        navigationController.modalPresentationStyle = .overCurrentContext
        self.present(navigationController, animated: true)
    }
    
    fileprivate func showAdvisory(for country: Country) {
        let advisoryDetailViewController = AdvisoryDetailViewController(country: country)
        if tabBarController?.splitViewController != nil &&
           tabBarController?.splitViewController?.traitCollection.isLargerDevice == true {
            let navigationController = UINavigationController(rootViewController: advisoryDetailViewController)
            tabBarController?.splitViewController?.showDetailViewController(navigationController, sender: nil)
        }
        else {
            navigationController?.pushViewController(advisoryDetailViewController, animated: true)
        }
    }

}

@available(iOS 11.0, *)
extension TripsTableViewController: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let trip = TripManager.shared.trips[indexPath.row]
        let string = trip.shareString as NSString
        let dragStringItem = UIDragItem(itemProvider: NSItemProvider(object: string))
        var dragURLItem: UIDragItem? = nil
        if trip.hasAdvisory,
           let url = trip.country.shareLink as NSURL? {
            dragURLItem = UIDragItem(itemProvider: NSItemProvider(object: url))
        }
        
        return [dragURLItem, dragStringItem].flatMap { $0 }
    }
    
}

// MARK: - UIDropInteractionDelegate
@available(iOS 11.0, *)
extension TripsTableViewController: UIDropInteractionDelegate {
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        guard let dropView = DropView(view: interaction.view) else { return false }
        switch dropView {
        case .navigationBar:
            return session.hasItemsConforming(toTypeIdentifiers: [kUTTypeText as String])
        case .tabBar:
            return session.hasItemsConforming(toTypeIdentifiers: [kUTTypeURL as String])
        }
        
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        guard let dropView = DropView(view: interaction.view) else { return UIDropProposal(operation: .forbidden) }
        switch dropView {
        case .navigationBar:
            if session.hasItemsConforming(toTypeIdentifiers: [kUTTypeText as String]) {
                return UIDropProposal(operation: .copy)
            }
        case .tabBar:
            if session.hasItemsConforming(toTypeIdentifiers: [kUTTypeURL as String]) {
                return UIDropProposal(operation: .copy)
            }
        }
        
        return UIDropProposal(operation: .forbidden)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        guard let dropView = DropView(view: interaction.view) else { return }
        switch dropView {
        case .navigationBar:
            session.loadObjects(ofClass: NSString.self) { [unowned self] (itemProviders) in
                // `NSItemProvider` allows both URLs and Strings to be cast to `NSString`
                // So filtering out by looking for "http" kind of crude but working for now.
                guard let itemProvider = itemProviders.flatMap({ $0 as? NSString }).filter({ !$0.contains("http") }).first,
                    let trip = Trip(string: itemProvider as String) else { return }
                self.showEdit(for: trip)
            }
        case .tabBar:
            session.loadObjects(ofClass: NSURL.self) { [unowned self] (itemProviders) in
                // `NSItemProvider` allows both URLs and Strings to be cast to `NSString`
                // So filtering out by looking for "http" kind of crude but working for now.
                guard let itemProvider = itemProviders.flatMap({ $0 as? NSURL }).first,
                      let country = Country(shareURL: itemProvider as URL) else { return }
                self.showAdvisory(for: country)
            }
        }
        
    }
}

// MARK: - UIViewControllerPreviewingDelegate
extension TripsTableViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location),
              let cell = tableView.cellForRow(at: indexPath) as? TripTableViewCell else { return nil }
        let rect = view.convert(cell.travelAdvisoryButton.bounds, from: cell.travelAdvisoryButton)
        guard rect.contains(location) else { return nil }
        previewingContext.sourceRect = rect
        let trip = TripManager.shared.trips[indexPath.row]
        let advisoryDetailViewController = AdvisoryDetailViewController(country: trip.country)
        
        return advisoryDetailViewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}

// MARK: - AddTripViewControllerDelegate
extension TripsTableViewController: AddTripViewControllerDelegate {
    func addTripViewController(_ viewController: AddTripViewController, didFinishWith trip: Trip) {
        let oldValue = TripManager.shared.trips
        TripManager.shared.add(trip)
        tableView.animateUpdate(oldDataSource: oldValue, newDataSource: TripManager.shared.trips)
    }
    
    func addTripViewController(_ viewController: AddTripViewController, didEdit editTrip: Trip, with trip: Trip) {
        let oldValue = TripManager.shared.trips
        TripManager.shared.edit(editTrip, with: trip)
        tableView.animateUpdate(oldDataSource: oldValue, newDataSource: TripManager.shared.trips)
    }
}
