//
//  Restaurants.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 11/2/23.
//

import Foundation

struct Restaurant: Decodable {
    let name: String
    let address: String
}

//struct Restaurant: Identifiable {
//    let id = UUID() // You can use a unique identifier if available
//    let name: String
//    let location: (lat: Double, lng: Double)
//    let photoURL: URL
//    let cuisine: String
//}
