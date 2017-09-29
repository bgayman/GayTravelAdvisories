//
//  UITabController+StatusBar.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/28/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

extension UITabBarController {
    
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        return selectedViewController
    }
    
}

extension UINavigationController {
    
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
}

extension UISplitViewController {
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        return viewControllers.first
    }
}

