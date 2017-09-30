//
//  UITraitCollection+Application.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/29/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

extension UITraitCollection {
    var isLargerDevice: Bool {
        return horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
}
