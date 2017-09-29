//
//  MapSnapshotClient.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/29/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import MapKit

struct MapSnapshotClient {
    
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
                }
                
            }
            
        }
    }
}
