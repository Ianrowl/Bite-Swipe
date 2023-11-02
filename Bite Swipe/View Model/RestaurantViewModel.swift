//
//  RestaurantViewModel.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 11/2/23.
//

import Foundation

class RestaurantViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []

    func fetchRestaurants() {
        RestaurantService.shared.fetchRestaurants { [weak self] restaurants in
            DispatchQueue.main.async {
                self?.restaurants = restaurants ?? []
            }
        }
    }
}

