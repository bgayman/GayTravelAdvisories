//
//  UIFont+Application.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/28/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

extension UIFont {
    @objc static func app_font(style: UIFontTextStyle, weight: UIFont.Weight) -> UIFont {
        let preferredFont = UIFont.preferredFont(forTextStyle: style)
        
        return UIFont.systemFont(ofSize: preferredFont.pointSize, weight: weight)
    }
}
