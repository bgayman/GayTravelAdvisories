//
//  CountriesManager+TestData.swift
//  Gay Travel Advisories
//
//  Created by Brad G. on 9/27/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import Foundation

extension CountriesManager {
    
    static func loadTestData() -> CountriesManager? {
        let bundle = Bundle(for: Gay_Travel_AdvisoriesTests.self)
        guard let url = bundle.url(forResource: "CountriesTestData", withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return nil }
        return CountriesManager.make(with: data)
    }
}
