//
//  NetworkActivityIndicatorManager.swift
//  Gay Travel Advisories
//
//  Created by Brad G. on 9/27/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

/// Small struct to manage network activity indicator

struct NetworkActivityIndicatorManager {
    
    static var shared = NetworkActivityIndicatorManager()
    
    private var networkIndicatorCount: Int = 0 {
        didSet {
            UIApplication.shared.isNetworkActivityIndicatorVisible = networkIndicatorCount > 0
        }
    }
    
    mutating func incrementIndicatorCount() {
        networkIndicatorCount += 1
    }
    
    mutating func decrementIndicatorCount() {
        networkIndicatorCount -= 1
    }
}
