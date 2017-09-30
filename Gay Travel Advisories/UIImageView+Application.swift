//
//  UIImageView+Application.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/30/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func flash() {
        guard let image = self.image else { return }
        let width = image.size.width
        let height = image.size.height
        
        let shineLayer = CALayer()
        let highlightImage = image.applyAppColorFilter(with: .white)
        shineLayer.contents = highlightImage?.cgImage
        shineLayer.frame = bounds
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor,
                                UIColor.clear.cgColor,
                                UIColor.black.cgColor,
                                UIColor.clear.cgColor,
                                UIColor.clear.cgColor]
        gradientLayer.locations = [0.0, 0.45, 0.50, 0.55, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        gradientLayer.frame = CGRect(x: -width, y: 0, width: width, height: height)
        
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.byValue = width * 2
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        layer.addSublayer(shineLayer)
        shineLayer.mask = gradientLayer
        
        gradientLayer.add(animation, forKey: "shine")
    }
}
