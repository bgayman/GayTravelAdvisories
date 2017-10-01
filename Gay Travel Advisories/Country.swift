//
//  Country.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/29/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import Foundation

struct Country {
    
    let abbreviation: String
    
    var detailLink: URL? {
        return URL(string: "https://www.scruff.com/gaytravel/advisories/\(abbreviation.lowercased())/index.json")
    }
    
    var flagImageLink: URL? {
        return URL(string: "https://bradgayman.com/Flags/flags/128/\(displayName?.replacingOccurrences(of: " ", with: " - ") ?? "").png")
    }
    
    var shareLink: URL? {
        return URL(string: "https://www.scruff.com/gaytravel/advisories/\(abbreviation.lowercased())")
    }
    
    var displayName: String? {
        return Locale.current.localizedString(forRegionCode: abbreviation)
    }
}

extension Country {
    
    init?(name: String?) {
        guard let abbreviation = Locale.isoRegionCodes.first(where: { Locale.current.localizedString(forRegionCode: $0) == name }) else { return nil }
        self = Country(abbreviation: abbreviation)
    }
    
    init?(shareURL: URL?) {
        guard let abbreviation = shareURL?.pathComponents.last else { return nil }
        self = Country(abbreviation: abbreviation)
    }
}
