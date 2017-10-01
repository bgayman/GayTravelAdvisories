//
//  PoorConnectionShowable.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/30/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

protocol PoorConnectionShowable: class {
    func showPoorConnection()
    func hidePoorConnection()
}

extension PoorConnectionShowable where Self: UITableViewController {
    
    func showPoorConnection() {
        navigationController?.showPoorConnectionView()
        guard var height = navigationController?.poorConnectionView?.bounds.height else { return }
        height = height - 20.0
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: height, right: 0.0)
    }
    
    func hidePoorConnection() {
        navigationController?.hidePoorConnectionView()
        tableView.contentInset = .zero
    }
}
