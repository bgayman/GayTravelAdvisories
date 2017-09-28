//
//  Region.swift
//  Gay Travel Advisories
//
//  Created by Brad G. on 9/27/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import Foundation

struct Region {
    
    let name: String
    let countries: [Country]
    
}

extension Region {
    
    init(name: String, abbreviations: [String]) {
        self.name = name
        self.countries = abbreviations.map(Country.init)
    }
}


struct Country {
    
    let abbreviation: String
    
    var detailLink: URL? {
        return URL(string: "https://www.scruff.com/gaytravel/advisories/\(abbreviation)/index.json")
    }
    
    var displayName: String? {
        return Locale.current.localizedString(forRegionCode: abbreviation)
    }
}
