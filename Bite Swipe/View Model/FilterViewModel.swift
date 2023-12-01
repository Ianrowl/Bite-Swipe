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
    @Published var showOnlyLiked: Bool = false
    
    // Other filter options can be added as needed
    
    func toggleLikedFilter() {
        showOnlyLiked.toggle()
    }
    
    func updateLikedRestaurants(_ likedRestaurants: [String]) {
        self.likedRestaurants = likedRestaurants
    }
    
    func updateSelectedCuisine(_ cuisine: String?) {
        selectedCuisine = cuisine
    }
    
    // Add more filter methods as needed
}

