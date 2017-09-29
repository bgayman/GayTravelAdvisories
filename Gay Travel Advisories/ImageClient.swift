//
//  ImageClient.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/29/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

struct ImageClient {
    
    static func getImage(at url: URL?, completion: @escaping (UIImage?) -> ()) {
        guard let url = url else {
            completion(nil)
            return
        }
        NetworkActivityIndicatorManager.shared.incrementIndicatorCount()
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            DispatchQueue.main.async {
                NetworkActivityIndicatorManager.shared.decrementIndicatorCount()
                guard let data = data else {
                    completion(nil)
                    return
                }
                let image = UIImage(data: data)
                completion(image)
            }
        }.resume()
    }
}
