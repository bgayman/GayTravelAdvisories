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

