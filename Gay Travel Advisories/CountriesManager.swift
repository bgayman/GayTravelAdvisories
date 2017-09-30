//
//  CountriesManager.swift
//  Gay Travel Advisories
//
//  Created by Brad G. on 9/27/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import Foundation

// MARK: - CountriesManager
class CountriesManager {
    
    // MARK: - Types
    struct Constants {
        static let advisoryIndexURL = URL(string: "https://www.scruff.com/gaytravel/advisories/index.json")!
    }
    
    enum Keys: String {
        case lastUpdate = "last_updated_timestamp"
    }
    
    // MARK: - Properties
    static var shared = CountriesManager()
    
    private(set) var regions: [Region]?
    private(set) var lastUpdated: Date?
    
    private(set) var allAbbreviations: [String]  = []
    
    // MARK: - Networking
    func getAdvisoryRegions(completion: ((Result<[Region]>) -> Void)? = nil) {
        
        // Load from disk if available
        if let data = FileStorage.cache["\(Constants.advisoryIndexURL.hashValue)"] {
            try? update(with: data)
        }
        
        // Update from server
        Webservice.dataTask(with: Constants.advisoryIndexURL) { (result) in
            switch result {
            case .error(let error):
                completion?(.error(error: error))
            case .success(let dictionary):
                self.update(with: dictionary)
                NotificationCenter.default.post(name: .CountriesManagerDidUpdate, object: nil)
                completion?(.success(response: self.regions ?? []))
                if let data = try? JSONSerialization.data(withJSONObject: dictionary, options: [.prettyPrinted]) {
                    FileStorage.cache["\(Constants.advisoryIndexURL.hashValue)"] = data
                }
                
            }
        }
    }
    
    // MARK: - Parsing
    fileprivate func update(with data: Data) throws {
        let dictionary = try JSONSerialization.jsonObject(with: data, options: [])
        
        guard let jsonDict = dictionary as? JSONDictionary else {
                throw WebserviceError.parseError
        }
        update(with: jsonDict)
    }
    
    fileprivate func update(with dictionary: JSONDictionary) {
        if let dateValue = dictionary[Keys.lastUpdate.rawValue] as? Double {
            lastUpdated = Date(timeIntervalSince1970: dateValue)
        }
        regions = dictionary.flatMap { $0 as? (String, [String]) }.map(Region.init)
        allAbbreviations = regions?.flatMap { $0.countries.map { $0.abbreviation } } ?? []
    }
}

// MARK: - Test Helpers
extension CountriesManager {
    static func make(with data: Data) -> CountriesManager? {
        let countriesManager = CountriesManager()
        try? countriesManager.update(with: data)
        return countriesManager
    }
}

