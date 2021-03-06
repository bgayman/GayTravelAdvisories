//
//  Trip.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/28/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import Foundation

// MARK: - Trip
struct Trip {
    
    // MARK: - Types
    enum Keys: String {
        case country
        case departureDate
        case returnDate
    }
    
    // MARK: - Properties
    static let dateIntervalFormatter: DateIntervalFormatter = {
        var dateIntervalFormatter = DateIntervalFormatter()
        dateIntervalFormatter.dateStyle = .medium
        dateIntervalFormatter.timeStyle = .none
        
        return dateIntervalFormatter
    }()
    
    static let dateFormatter = DateFormatter()
    
    let country: Country
    let departureDate: Date
    let returnDate: Date
    
    var dictionary: JSONDictionary {
        return [Keys.country.rawValue: country.abbreviation,
                Keys.departureDate.rawValue: departureDate.timeIntervalSince1970,
                Keys.returnDate.rawValue: returnDate.timeIntervalSince1970]
    }
    
    var dateIntervalString: String {
        return Trip.dateIntervalFormatter.string(from: departureDate, to: returnDate)
    }
    
    var shareString: String {
        return [country.displayName,
                Trip.dateFormatter.string(from: departureDate),
                Trip.dateFormatter.string(from: returnDate)]
            .flatMap { $0 }
            .joined(separator: "\n")
    }
    
    var hasAdvisory: Bool {
        return CountriesManager.shared.allAbbreviations.contains(country.abbreviation.lowercased())
    }
}

// MARK: - Init
extension Trip {
    
    init?(dictionary: JSONDictionary) {
        guard let countryValue = dictionary[Keys.country.rawValue] as? String,
              let departureDateValue = dictionary[Keys.departureDate.rawValue] as? Double,
              let returnDateValue = dictionary[Keys.returnDate.rawValue] as? Double else { return nil }
        self.country = Country(abbreviation: countryValue)
        self.departureDate = Date(timeIntervalSince1970: departureDateValue)
        self.returnDate = Date(timeIntervalSince1970: returnDateValue)
    }
    
    init?(string: String) {
        let components = string.components(separatedBy: "\n")
        guard components.count == 3,
              let country = Country(name: components.first),
              let departureDate = Trip.dateFormatter.date(from: components[1]),
              let returnDate = Trip.dateFormatter.date(from: components[2]) else { return nil }
        self.country = country
        self.departureDate = departureDate
        self.returnDate = returnDate
    }
}

// MARK: - Equatable
extension Trip: Equatable {
    static func == (lhs: Trip, rhs: Trip) -> Bool {
        return lhs.country.abbreviation == rhs.country.abbreviation && lhs.departureDate == rhs.departureDate && lhs.returnDate == rhs.returnDate
    }
}

// MARK: - Comparable
extension Trip: Comparable {
    static func < (lhs: Trip, rhs: Trip) -> Bool {
        if lhs.departureDate == rhs.departureDate {
            return lhs.country.abbreviation < rhs.country.abbreviation
        }
        
        return lhs.departureDate < rhs.departureDate
    }
}

// MARK: - Hashable
extension Trip: Hashable {
    var hashValue: Int {
        return country.abbreviation.hashValue ^ departureDate.hashValue ^ returnDate.hashValue
    }
}
