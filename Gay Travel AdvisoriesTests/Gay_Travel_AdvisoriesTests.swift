//
//  Gay_Travel_AdvisoriesTests.swift
//  Gay Travel AdvisoriesTests
//
//  Created by Brad G. on 9/27/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import XCTest
@testable import Gay_Travel_Advisories

class Gay_Travel_AdvisoriesTests: XCTestCase {
    
    var countriesManager: CountriesManager?
    var travelAdvisory: TravelAdvisory?
    
    override func setUp() {
        super.setUp()
        countriesManager = CountriesManager.loadTestData()
        travelAdvisory = TravelAdvisory.loadTestData()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCountriesLoadingFromServer() {
        let serverExpectation = expectation(description: "Loading from server.")
        CountriesManager.shared.getAdvisoryRegions { (result) in
            switch result {
            case .error(let error):
                XCTFail("Response was error: \(error.localizedDescription)")
            case .success:
                serverExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 60.0) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }
    
    func testCountriesParsing() {
        XCTAssertNotNil(countriesManager, "countriesManager must be non nil.")
        XCTAssertEqual(countriesManager?.regions?.count, 5, "countriesManager must have 5 regions")
    }
    
    func testTravelAdvisoryLoadingFromServer() {
        let serverExpectation = expectation(description: "Loading from server.")
        let country = countriesManager?.regions?.first?.countries.first
        XCTAssertNotNil(country, "country must be non nil.")
        TravelAdvisoryClient.getTravelAdvisory(for: country!) { (result) in
            switch result {
            case .error(let error):
                XCTFail("Response was error: \(error.localizedDescription)")
            case .success:
                serverExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 60.0) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }
    
    func testTravelAdvisoryParsing() {
        XCTAssertNotNil(travelAdvisory, "travelAdvisory must be non nil.")
        XCTAssertEqual(travelAdvisory?.fine.minAmount, 500, "travelAdvisory min fine amount must be 500")
    }
}
