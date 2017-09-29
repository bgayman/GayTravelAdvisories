//
//  FileStorage.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/28/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import Foundation

struct FileStorage {
    static var shared = FileStorage()
    
    let baseURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    
    subscript(key: String) -> Data? {
        get {
            let url = baseURL.appendingPathComponent(key)
            return try? Data(contentsOf: url)
        }
        
        set {
            let url = baseURL.appendingPathComponent(key)
            _ = try? newValue?.write(to: url)
        }
    }
}
