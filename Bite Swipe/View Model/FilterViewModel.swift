//
//  FilterViewModel.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 11/16/23.
//

import Foundation

class FilterViewModel: ObservableObject {
    @Published var likedRestaurants: [String] = []
    @Published var selectedCuisine: String?
    @Published var selectedRestaurant: Restaurant?
    @Published var isModalPresented = false
    
    func updateLikedRestaurants(_ likedRestaurants: [String]) {
        self.likedRestaurants = likedRestaurants
    }
    
    func updateSelectedCuisine(_ cuisine: String?) {
        selectedCuisine = cuisine
    }
    
}

