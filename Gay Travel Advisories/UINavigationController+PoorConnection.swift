//
//  UINavigationController+PoorConnection.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/30/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    var poorConnectionView: PoorConnectionView? {
        return view.subviews.first(where: { $0 is PoorConnectionView }) as? PoorConnectionView
    }
    
    func showPoorConnectionView() {
        // Only want one of these per view hierarchy
        guard self.poorConnectionView == nil  else { return }
        
        let frame = CGRect(x: 0.0,
                           y: view.bounds.height - PoorConnectionView.height + 20.0 - bottomLayoutGuide.length,
                           width: view.bounds.width,
                           height: PoorConnectionView.height)
        let poorConnectionView = PoorConnectionView(frame: frame)
        poorConnectionView.setNeedsLayout()

        view.addSubview(poorConnectionView)
        poorConnectionView.showPoorConnection()
    }
    
    func hidePoorConnectionView() {
        poorConnectionView?.hidePoorConnection()
    }
}
