//
//  AppDelegate.swift
//  Gay Travel Advisories
//
//  Created by Brad G. on 9/27/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        CountriesManager.shared.getAdvisoryRegions()
        
        if let splitViewController = window?.rootViewController as? UISplitViewController {
            splitViewController.preferredDisplayMode = .allVisible
        }
        
        return true
    }

}

