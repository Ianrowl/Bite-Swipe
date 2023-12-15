//
//  RestaurantViewModel.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 11/2/23.
//

import Foundation

class RestaurantViewModel: ObservableObject {
    @Published var zipCodeInput: String = ""
    @Published var currentZipCode: String = ""
    @Published var currentIndex = 0
    @Published var currentPhotoIndex = 0

    @Published var restaurants: [Restaurant] = []
    private let restaurantService = RestaurantService()
    @Published var currentRestaurant: Restaurant?
    @Published var photos: [Photo] = []
    
    var lastFetchedZipCode: String?
    private let currentIndexKey = "currentIndex"
    
    public var publicZipCodeKey: String {
        return zipCodeKey
    }
    
    private let zipCodeKey = "zipCode"
    private let currentZipCodeKey = "currentZipCode"
            
    @Published var likedRestaurants: [String]
    
    private let likedKey = "likedRestaurants"
    private let dislikedKey = "dislikedRestaurants"
    
    static let shared = RestaurantViewModel()

    internal init() {
        likedRestaurants = []
        loadLikedRestaurants()
    }

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
            UserDefaults.standard.set(likedRestaurants, forKey: likedKey)
            print("Liked Restaurants: \(likedRestaurants)")
        }
    }

    func dislikeRestaurant(_ restaurantID: String) {
        var dislikedRestaurants = UserDefaults.standard.stringArray(forKey: dislikedKey) ?? []
        dislikedRestaurants.append(restaurantID)
        UserDefaults.standard.set(dislikedRestaurants, forKey: dislikedKey)
    }
    
    private func saveZipCode() {
        UserDefaults.standard.set(zipCodeInput, forKey: zipCodeKey)
    }

    // Function to load the zip code from UserDefaults
    private func loadZipCode() {
        if let savedZipCode = UserDefaults.standard.value(forKey: zipCodeKey) as? String {
            zipCodeInput = savedZipCode
        }
    }
    
    private func saveCurrentZipCode() {
        UserDefaults.standard.set(currentZipCode, forKey: zipCodeKey)
    }

    // Function to load the zip code from UserDefaults
    private func loadCurrentZipCode() {
        if let savedZipCode = UserDefaults.standard.value(forKey: currentZipCodeKey) as? String {
            currentZipCode = savedZipCode
        }
    }
    
    func fetchRestaurants(completion: @escaping (Bool) -> Void) {
        restaurantService.fetchRestaurants(zipCode: zipCodeInput) { [weak self] restaurants in
            if let restaurants = restaurants {
                DispatchQueue.main.async {
                    self?.restaurants = restaurants

                    // Check if the zip code has changed
                    if self?.lastFetchedZipCode != self?.zipCodeInput {
                        // Zip code has changed, load liked restaurants
                        self?.loadLikedRestaurants()
                        // Update the last fetched zip code
                        self?.lastFetchedZipCode = self?.zipCodeInput

                        // Restore the current index from UserDefaults
                        if let savedIndex = UserDefaults.standard.value(forKey: self?.currentIndexKey ?? "") as? Int {
                            self?.currentIndex = savedIndex
                        }

                        // Ensure currentIndex is within bounds
                        if self?.currentIndex ?? 0 >= self?.restaurants.count ?? 0 {
                            self?.currentIndex = 0
                        }
                    }

                    // Save the zip code to UserDefaults
                    self?.saveZipCode()

                    // Call the completion handler with success
                    completion(true)
                }
            } else {
                // Call the completion handler with failure
                completion(false)
            }
        }
    }




    
    private func saveCurrentIndex() {
        UserDefaults.standard.set(currentIndex, forKey: currentIndexKey)
    }

    func resetCurrentIndex() { // Function to reset the current index
        currentIndex = 0
        saveCurrentIndex()
    }
    
    func incrementIndex() { // Function to increment the current index
        currentIndex += 1
        saveCurrentIndex()
    }

    func loadLikedRestaurants() {
        likedRestaurants = UserDefaults.standard.stringArray(forKey: likedKey) ?? []
        print("Loaded Liked Restaurants: \(likedRestaurants)")
    }


//    func fetchRestaurants() {
//        restaurantService.fetchRestaurants(zipCode: zipCodeInput) { [weak self] restaurants in
//            if let restaurants = restaurants {
//                DispatchQueue.main.async {
//                    self?.restaurants = restaurants
//                }
//            }
//        }
//    }
    func isValidZipCode(_ zipCode: String) -> Bool {
        let zipCodeRegex = "^\\d{5}$"
        let zipCodePredicate = NSPredicate(format: "SELF MATCHES %@", zipCodeRegex)
        return zipCodePredicate.evaluate(with: zipCode)
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
    
    func resetApp() {
        zipCodeInput = ""
        currentZipCode = ""
        saveZipCode()

        likedRestaurants = []
        UserDefaults.standard.removeObject(forKey: likedKey)

        objectWillChange.send()
    }
}

