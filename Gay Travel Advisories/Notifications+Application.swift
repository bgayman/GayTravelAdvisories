//
//  Notifications+Application.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/28/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let CountriesManagerDidUpdate = Notification.Name("CountriesManagerDidUpdate")
}

extension NotificationCenter {
    func when(_ name: Notification.Name, perform block: @escaping (Notification) -> ()) {
        NotificationCenter.default.addObserver(forName: name, object: nil, queue: .main, using: block)
    }
}
