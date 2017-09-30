//
//  MapSnapshotClient.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/29/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import MapKit

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
        if let data = FileStorage.cache["\(country.abbreviation)Image"] {
            completion(UIImage(data: data))
        }
        
        // Get from MKMapSnapshotter
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(name) { (placemarks, _) in
            DispatchQueue.main.async {
                guard let placemark = placemarks?.first,
                      let coordinates = placemark.location?.coordinate else {
                    completion(nil)
                        return
                }
                MapSnapshotClient.options.camera = MKMapCamera(lookingAtCenter: coordinates, fromDistance: 720000, pitch: 0, heading: 0)
                let snapshotter = MKMapSnapshotter(options: MapSnapshotClient.options)
                snapshotter.start { (snapshot, _) in
                    completion(snapshot?.image)
                    if let image = snapshot?.image {
                        MapSnapshotClient.imageCache[country.abbreviation] = image
                        FileStorage.cache["\(country.abbreviation)Image"] = UIImagePNGRepresentation(image)
                    }
                }
            }
        }
    }
}
