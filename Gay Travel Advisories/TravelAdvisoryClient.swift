//
//  TravelAdvisoryClient.swift
//  Gay Travel Advisories
//
//  Created by Brad G. on 9/27/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import Foundation

struct TravelAdvisoryClient {
    
    static func getTravelAdvisory(for country: Country, completion: @escaping (Result<TravelAdvisory>) -> Void) {
        guard let url = country.detailLink else {
            completion(.error(error: WebserviceError.invalidURL))
            
            return
        }
        
        Webservice.dataTask(with: url) { (result) in
            switch result {
            case .error(let error):
                completion(.error(error: error))
            case .success(let dictionary):
                guard let travelAdvisory = TravelAdvisory(dictionary: dictionary) else {
                    completion(.error(error: WebserviceError.parseError))
                    
                    return
                }
                completion(.success(response: travelAdvisory))
            }
        }
    }
}
