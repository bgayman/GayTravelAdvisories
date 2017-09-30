//
//  AdvisoryDetailEmptyViewController.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/29/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

// MARK: - AdvisoryDetailEmptyViewController
class AdvisoryDetailEmptyViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!
    
    // MARK: - Lifecycle
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
        
        imageView.tintColor = UIColor.app_pink
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.app_font(style: .headline, weight: .bold)
    }
}
