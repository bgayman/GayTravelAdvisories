//
//  ErrorHandleable.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/29/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

protocol ErrorHandleable: class {
    func handle(_ error: Error?)
}

extension ErrorHandleable where Self: UIViewController {
    func handle(_ error: Error?) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        let alert = UIAlertController(error: error)
        alert.view.tintColor = .app_pink
        present(alert, animated: true)
    }
}
