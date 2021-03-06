//
//  MapSnapshotClient.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/29/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import MapKit
import Contacts

struct MapSnapshotClient {
    
    static fileprivate var imageCache = [String: UIImage]()
    
    static var options: MKMapSnapshotOptions = {
        let options = MKMapSnapshotOptions()
        options.mapType = .standard
        options.showsPointsOfInterest = false
        options.scale = UIScreen.main.scale
        
        return options
    }()
    
    static func getSnapshot(of country: Country, size: CGSize, completion: @escaping (UIImage?) -> ()) {
        guard let name = country.displayName else {
            completion(nil)
            
            return
        }
        
        // Check if in memory
        guard MapSnapshotClient.imageCache[country.abbreviation] == nil else {
            completion(MapSnapshotClient.imageCache[country.abbreviation]!)
            
            return
        }
        
        // Check if it is on disk
        let cachedData = FileStorage.cache["\(country.abbreviation)Image"]
        if let data = cachedData {
            completion(UIImage(data: data))
        }
        
        // `CLGeocoder` places "Grenada" in New Jersey if `CNPostalAddressCountryKey` is added
        // Other countries are misplaced if `CNPostalAddressCountryKey` is not added
        let dictionary = name == "Grenada" ? [CNPostalAddressISOCountryCodeKey: country.abbreviation.uppercased()] : [CNPostalAddressCountryKey: name, CNPostalAddressISOCountryCodeKey: country.abbreviation.uppercased()]
        
        // Get from MKMapSnapshotter
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressDictionary(dictionary) { (placemarks, _) in
            DispatchQueue.main.async {
                guard let placemark = placemarks?.first,
                      let coordinates = placemark.location?.coordinate,
                      let region = placemark.region as? CLCircularRegion else {
                    completion(nil)
                        
                        return
                }
                MapSnapshotClient.options.camera = MKMapCamera(lookingAtCenter: coordinates, fromDistance: region.radius * 6, pitch: 0, heading: 0)
                let snapshotter = MKMapSnapshotter(options: MapSnapshotClient.options)
                snapshotter.start { (snapshot, _) in
                    guard let image = snapshot?.image else {
                        
                        // Only return nil if image isn't cached
                        if cachedData == nil {
                            completion(nil)
                        }
                        
                        return
                    }
                    completion(image)
                    if let image = snapshot?.image {
                        MapSnapshotClient.imageCache[country.abbreviation] = image
                        FileStorage.cache["\(country.abbreviation)Image"] = UIImagePNGRepresentation(image)
                    }
                }
            }
        }
    }
}
