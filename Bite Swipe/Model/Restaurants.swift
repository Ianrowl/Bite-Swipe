//
//  Restaurants.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 11/2/23.
//

import Foundation

struct Restaurant: Identifiable {
    let fsq_id: String
    let id = UUID()
    let name: String
    let cuisine: String
    let location: String
}
