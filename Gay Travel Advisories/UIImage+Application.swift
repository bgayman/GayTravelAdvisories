//
//  UIImage+Application.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/30/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit
import CoreImage

extension UIImage {
    
    func applyAppColorFilter(with color: UIColor) -> UIImage? {
        guard let ciImage = CIImage(image: self) else { return nil }
        let color = CIColor(color: color)
        let imageAppColors = ciImage.applyingFilter("CIColorMonochrome", parameters: [kCIInputColorKey: color])
        guard let cgImage = CIContext().createCGImage(imageAppColors, from: imageAppColors.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
    
}
