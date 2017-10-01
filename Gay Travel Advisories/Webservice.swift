//
//  Webservice.swift
//  Gay Travel Advisories
//
//  Created by Brad G. on 9/27/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import Foundation
import CoreFoundation

enum WebserviceError: Error {
    case noData
    case parseError
    case invalidURL
}

/// Small wrapper around URLSession

struct Webservice {
    
    static func dataTask(with request: URLRequest, completion: @escaping (Result<JSONDictionary>) -> Void) {
        NetworkActivityIndicatorManager.shared.incrementIndicatorCount()
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                NetworkActivityIndicatorManager.shared.decrementIndicatorCount()
            }
            
            guard error == nil else {
                DispatchQueue.main.async {
                    let code = (error as NSError?)?.code
                    if code == NSURLErrorNotConnectedToInternet ||
                        code == NSURLErrorCannotConnectToHost ||
                        code == NSURLErrorTimedOut ||
                        code == NSURLErrorNetworkConnectionLost {
                        NotificationCenter.default.post(name: .WebserviceDidFailToConnect, object: nil)
                    }
                    completion(.error(error: error!))
                }
                return
            }
            NotificationCenter.default.post(name: .WebserviceDidConnect, object: nil)
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.error(error: WebserviceError.noData))
                }
                return
            }
            do {
                let object = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                guard let dictionary = object as? JSONDictionary else {
                    DispatchQueue.main.async {
                        completion(.error(error: WebserviceError.parseError))
                    }
                    return
                }
                DispatchQueue.main.async {
                    completion(.success(response: dictionary))
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(.error(error: error))
                }
            }
        }.resume()
    }
    
    static func dataTask(with url: URL, completion: @escaping (Result<JSONDictionary>) -> Void) {
        let request = URLRequest(url: url)
        Webservice.dataTask(with: request, completion: completion)
    }
}
