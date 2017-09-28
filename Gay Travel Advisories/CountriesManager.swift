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
    
    var regions: [Region]?
    var lastUpdated: Date?
    
    // MARK: - Networking
    func getAdvisoryRegions(completion: @escaping (Result<[Region]>) -> Void) {
        
        Webservice.dataTask(with: Constants.advisoryIndexURL) { (result) in
            switch result {
            case .error(let error):
                completion(.error(error: error))
            case .success(let dictionary):
                self.update(with: dictionary)
                completion(.success(response: self.regions ?? []))
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

