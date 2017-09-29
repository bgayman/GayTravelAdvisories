//
//  AdvisoryDetailViewController.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/29/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

// MARK: - AdvisoryDetailViewController
class AdvisoryDetailViewController: UIViewController {

    // MARK: - Properties
    fileprivate let country: Country
    fileprivate var travelAdvisory: TravelAdvisory?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Outlets
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet var tableHeaderView: UIView!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var mapActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var countryNameLabel: UILabel!
    
    // MARK: - Lifecycle
    init(country: Country) {
        self.country = country
        super.init(nibName: "\(AdvisoryDetailViewController.self)", bundle: nil)
        getTravelAdvisory()
        getFlagImage()
        getMapImage()
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
        navigationController?.navigationBar.tintColor = UIColor.app_orange
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        
        view.backgroundColor = UIColor.app_black
        title = "Travel Advisory"
        
        countryNameLabel.font = UIFont.app_font(style: .title1, weight: UIFont.Weight.heavy)
        countryNameLabel.textColor = .white
        countryNameLabel.text = country.displayName
        
        tableView.backgroundColor = .clear
        tableView.tableHeaderView = tableHeaderView
        tableHeaderView.backgroundColor = .app_black
        tableHeaderView.heightAnchor.constraint(equalToConstant: 250.0).isActive = true
    }
    
    // MARK: - Networking
    fileprivate func getTravelAdvisory() {
        TravelAdvisoryClient.getTravelAdvisory(for: country) { (result) in
            switch result {
            // TODO: - Handle Error
            case .error:
                break
            case .success(let travelAdvisory):
                self.travelAdvisory = travelAdvisory
            }
        }
    }
    
    fileprivate func getFlagImage() {
        ImageClient.getImage(at: country.flagImageLink) { (image) in
            self.flagImageView.image = image
        }
    }
    
    fileprivate func getMapImage() {
        let size = CGSize(width: UIScreen.main.bounds.width, height: 250.0)
        MapSnapshotClient.getSnapshot(of: country, size: size) { (image) in
            self.mapImageView.image = image
            self.mapActivityIndicator.stopAnimating()
        }
    }
}

extension AdvisoryDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
