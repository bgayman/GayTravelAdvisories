//
//  UIAlertController+Application.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/29/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

extension UIAlertController {
    convenience init(error: Error?, title: String? = nil) {
        self.init(title: title ?? "Error", message: error?.localizedDescription ?? "Oops, something went wrong.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        self.addAction(okAction)
    }
    
    convenience init(title: String? = nil, message: String?) {
        self.init(title: title ?? "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        self.addAction(okAction)
    }
}
