//
//  RestaurantViewModel.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 11/2/23.
//

// RestaurantViewModel.swift

import Foundation

class RestaurantViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    private let restaurantService = RestaurantService()

    func fetchRestaurants() {
        restaurantService.fetchRestaurants { [weak self] restaurants in
            if let restaurants = restaurants {
                DispatchQueue.main.async {
                    self?.restaurants = restaurants
                }
            }
        }
    }
}
