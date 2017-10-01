//
//  TripManager.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/28/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import Foundation

struct TripManager {
    
    private struct Constants {
        static let userTripsKey = "userTripsKey"
    }
    
    static var shared: TripManager = {
        var shared = TripManager()
        shared.loadTripsFromDisk()
        
        return shared
    }()
    
    fileprivate(set) var trips = [Trip]()
    
    private mutating func loadTripsFromDisk() {
        guard let data = FileStorage.shared[Constants.userTripsKey],
              let object = try? JSONSerialization.jsonObject(with: data, options: []),
              let jsonArray = object as? [JSONDictionary] else { return }
        self.trips = jsonArray.flatMap(Trip.init)
    }
    
    mutating func add(_ trip: Trip) {
        trips = (self.trips + [trip]).sorted()
        saveToDisk()
    }
    
    mutating func remove(_ trip: Trip) {
        guard let index = trips.index(of: trip) else { return }
        trips.remove(at: index)
        saveToDisk()
    }
    
    mutating func edit(_ editTrip: Trip, with trip: Trip) {
        guard let index = trips.index(of: editTrip) else { return }
        trips.remove(at: index)
        add(trip)
    }
    
    private func saveToDisk() {
        guard let data = try? JSONSerialization.data(withJSONObject: self.trips.map { $0.dictionary }, options: [.prettyPrinted]) else { return }
        DispatchQueue.global(qos: .default).async {
            FileStorage.shared[Constants.userTripsKey] = data
        }
    }
    
}
