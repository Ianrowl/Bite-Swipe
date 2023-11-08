//
//  Restaurants.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 11/2/23.
//


//struct Restaurant {
//    let name: String
//    let cuisine: String
//    let location: String
//}
//

import Foundation

struct Restaurant: Identifiable {
    let id = UUID()
    let name: String
    let cuisine: String
    let location: String
}
