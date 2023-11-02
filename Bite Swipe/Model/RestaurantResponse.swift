//
//  RestaurantResponse.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 11/2/23.
//

import Foundation

struct RestaurantResponse: Decodable {
    let results: [Restaurant]
}

