//
//  Restaurants.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 11/2/23.
//

import Foundation

struct Restaurant: Identifiable, Equatable {
    let id: UUID
    let fsq_id: String
    let name: String
    let cuisine: String
    let location: String
    let latitude: Double
    let longitude: Double

    init(id: UUID = UUID(), fsq_id: String, name: String, cuisine: String, location: String, latitude: Double, longitude: Double) {
        self.id = id
        self.fsq_id = fsq_id
        self.name = name
        self.cuisine = cuisine
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
    }
}

