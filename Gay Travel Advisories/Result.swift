//
//  Result.swift
//  Gay Travel Advisories
//
//  Created by Brad G. on 9/27/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: Any]

enum Result<T> {
    case error(error: Error)
    case success(response: T)
}
