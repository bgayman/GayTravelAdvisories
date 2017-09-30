//
//  AdvisoryDetailViewController.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/29/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit
import CoreImage

// MARK: - AdvisoryDetailViewController
class AdvisoryDetailViewController: UIViewController, ErrorHandleable {

    // MARK: - Properties
    fileprivate let country: Country
    fileprivate var travelAdvisory: TravelAdvisory?
    fileprivate var travelAdvisoryViewModel: TravelAdvisoryViewModel?
    
    override var previewActionItems: [UIPreviewActionItem] {
        let shareActionItem = UIPreviewAction(title: "Share", style: .default) { _, viewController in
            guard let viewController = viewController as? AdvisoryDetailViewController,
                  let url = viewController.country.shareLink else { return  }
            let controller = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            UIApplication.shared.keyWindow?.rootViewController?.present(controller, animated: true)
        }
        return [shareActionItem]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    lazy var actionBarButtonItem: UIBarButtonItem = {
        let actionBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.didPressAction(_:)))
        return actionBarButtonItem
    }()
    
    let ciContext = CIContext()
    
    // MARK: - Outlets
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate var tableHeaderView: UIView!
    @IBOutlet fileprivate weak var mapImageView: UIImageView!
    @IBOutlet fileprivate weak var flagImageView: UIImageView!
    @IBOutlet fileprivate weak var mapActivityIndicator: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var countryNameLabel: UILabel!
    @IBOutlet fileprivate weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    init(country: Country) {
        self.country = country
        super.init(nibName: "\(AdvisoryDetailViewController.self)", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTravelAdvisory()
        getFlagImage()
        getMapImage()
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
        tableView.estimatedRowHeight = 150.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.estimatedSectionHeaderHeight = 50.0
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        
        let nib = UINib(nibName: "\(AdvisoryTableViewCell.self)", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "\(AdvisoryTableViewCell.self)")
        tableView.separatorStyle = .none
        
        if country.shareLink != nil {
            navigationItem.rightBarButtonItem = actionBarButtonItem
        }
    }
    
    // MARK: - Networking
    fileprivate func getTravelAdvisory() {
        activityIndicator.startAnimating()
        TravelAdvisoryClient.getTravelAdvisory(for: country) { (result) in
            self.activityIndicator.stopAnimating()
            switch result {
            case .error(let error):
                self.handle(error)
            case .success(let travelAdvisory):
                let oldValue = self.travelAdvisoryViewModel?.sections
                self.travelAdvisory = travelAdvisory
                self.travelAdvisoryViewModel = TravelAdvisoryViewModel(travelAdvisory: travelAdvisory)
                self.tableView.animateSectionUpdate(oldDataSource: oldValue ?? [], newDataSource: self.travelAdvisoryViewModel?.sections ?? [])
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
            self.mapImageView.image = self.applyAppColorFilter(to: image)
            self.mapActivityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Actions
    @objc
    fileprivate func didPressAction(_ sender: UIBarButtonItem) {
        guard let shareLink = country.shareLink else { return }
        let activityViewContoller = UIActivityViewController(activityItems: [shareLink], applicationActivities: nil)
        activityViewContoller.popoverPresentationController?.barButtonItem = sender
        present(activityViewContoller, animated: true)
    }
    
    // MARK: - Helpers
    private func applyAppColorFilter(to image: UIImage?) -> UIImage? {
        guard let image = image,
              let ciImage = CIImage(image: image) else { return nil }
        let imageAppColors = ciImage.applyingFilter("CIColorInvert", parameters: [:])
        guard let cgImage = ciContext.createCGImage(imageAppColors, from: imageAppColors.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}

// MARK: - UITableViewDataSource / UITableViewDelegate
extension AdvisoryDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return travelAdvisoryViewModel?.sections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return travelAdvisoryViewModel?.sections[section].sectionTitle
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let view = view as? UITableViewHeaderFooterView else { return }
        view.backgroundView?.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        view.textLabel?.textColor = UIColor.app_purple
        view.textLabel?.font = UIFont.app_font(style: .headline, weight: .black)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(AdvisoryTableViewCell.self)", for: indexPath) as! AdvisoryTableViewCell
        
        guard let section = travelAdvisoryViewModel?.sections[indexPath.section] else { return UITableViewCell() }
        switch section {
        case .legalCode(let text):
            cell.attributedText = text
        case .penalty(let text):
            cell.attributedText = text
        case .fine(let text):
            cell.attributedText = text
        case .prisonTerm(let text):
            cell.attributedText = text
        case .shariaLaw(let text):
            cell.attributedText = text
        case .propagandaLaw(let text):
            cell.attributedText = text
        }
        return cell
    }
}
