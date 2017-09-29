//
//  UIView+Application.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/28/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

extension UIView {
    
    @objc func shakeNo() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
        
        self.transform = CGAffineTransform(translationX: 20.0, y: 0.0)
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: [], animations: { [unowned self] in
                self.transform = .identity
        })
    }
}
