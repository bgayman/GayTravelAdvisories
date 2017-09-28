//
//  TravelAdvisory+TestData.swift
//  Gay Travel Advisories
//
//  Created by Brad G. on 9/27/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import Foundation

extension TravelAdvisory {
    
    static func loadTestData() -> TravelAdvisory? {
        let bundle = Bundle(for: Gay_Travel_AdvisoriesTests.self)
        guard let url = bundle.url(forResource: "TravelAdvisoryTestData", withExtension: "json"),
            let data = try? Data(contentsOf: url) else { return nil }
        return try? TravelAdvisory(data: data)
    }
}
