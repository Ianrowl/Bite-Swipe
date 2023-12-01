//
//  RestaurantViewModel.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 11/2/23.
//

import Foundation

class RestaurantViewModel: ObservableObject {
    @Published var zipCodeInput = ""
    @Published var currentIndex = 0
    @Published var currentPhotoIndex = 0 // Add this line

    @Published var restaurants: [Restaurant] = []
    private let restaurantService = RestaurantService()
    
    private let likedKey = "likedRestaurants"
    private let dislikedKey = "dislikedRestaurants"

    var likedRestaurants: [String] = [] // Assuming fsq_id is a String, adjust accordingly
    

    func likeRestaurant(_ restaurantID: String) {
        if !likedRestaurants.contains(restaurantID) {
            likedRestaurants.append(restaurantID)
            print("Liked Restaurants: \(likedRestaurants)")
        }
    }

    func dislikeRestaurant(_ restaurantID: String) {
        var dislikedRestaurants = UserDefaults.standard.stringArray(forKey: dislikedKey) ?? []
        dislikedRestaurants.append(restaurantID)
        UserDefaults.standard.set(dislikedRestaurants, forKey: dislikedKey)
    }


    func fetchRestaurants() {
        restaurantService.fetchRestaurants(zipCode: zipCodeInput) { [weak self] restaurants in
            if let restaurants = restaurants {
                DispatchQueue.main.async {
                    self?.restaurants = restaurants
                }
            }
        }
    }
}
