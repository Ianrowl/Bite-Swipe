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
    @Published var currentPhotoIndex = 0

    @Published var restaurants: [Restaurant] = []
    private let restaurantService = RestaurantService()
    @Published var currentRestaurant: Restaurant?
    @Published var photos: [Photo] = []
    
    @Published var selectedPhoto: Photo?
    
    @Published var likedRestaurants: [String] = []

    
    private let likedKey = "likedRestaurants"
    private let dislikedKey = "dislikedRestaurants"

    func createPhotoURL(photo: Photo) -> URL {
        let urlString = "\(photo.prefix)original\(photo.suffix)"
        return URL(string: urlString)!
    }
    
    func resetPhotos() {
        photos = []
    }
    
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
    
    func fetchPhotos(for restaurant: Restaurant) {
//        selectedPhoto = photos.randomElement()

        RestaurantService().fetchPhotos(venueID: restaurant.fsq_id) { result in
            switch result {
            case .success(let fetchedPhotos):
                DispatchQueue.main.async {
                    if let fetchedPhotos = fetchedPhotos, !fetchedPhotos.isEmpty {
                        self.photos = fetchedPhotos
                    } else {
                        self.photos = []
                    }
                }
            case .failure(let error):
                print("Error fetching photos: \(error)")
            }
        }
    }
}

