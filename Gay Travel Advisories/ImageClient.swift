//
//  ImageClient.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/29/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

struct ImageClient {
    
    static fileprivate var imageCache = [URL: UIImage?]()
    
    static func getImage(at url: URL?, completion: @escaping (UIImage?) -> ()) {
        guard let url = url else {
            completion(nil)
            
            return
        }
        
        // Check if in memory
        guard ImageClient.imageCache[url] == nil else {
            completion(ImageClient.imageCache[url]!)
            
            return
        }
        
        // Check if on disk
        if let cachedData = FileStorage.cache["\(url.hashValue)"] {
            let image = UIImage(data: cachedData)
            completion(image)
        }
        
        // Get off the network
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
                ImageClient.imageCache[url] = image
                FileStorage.cache["\(url.hashValue)"] = data
            }
            
        }.resume()
    }
}
