//
//  FilterView.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 11/16/23.
//

import SwiftUI

struct FilterView: View {
    @EnvironmentObject var filterViewModel: FilterViewModel
    @EnvironmentObject var restaurantViewModel: RestaurantViewModel
    @State private var searchText: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Search")) {
                    TextField("Search", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                Section(header: Text("Select Cuisine")) {
                    Picker("Select Cuisine", selection: $filterViewModel.selectedCuisine) {
                        Text("All Cuisines").tag(nil as String?)
                        ForEach(likedCuisines().sorted(), id: \.self) { cuisine in
                            Text(cuisine).tag(cuisine as String?)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 120)
                 }

                Section(header: Text("Liked Restaurants")) {
                    if restaurantViewModel.likedRestaurants.isEmpty {
                        Text("No liked restaurants found.")
                    } else {
                        ForEach(filteredLikedRestaurants(), id: \.self) { fsq_id in
                            if let restaurant = restaurantViewModel.restaurants.first(where: { $0.fsq_id == fsq_id }) {
                                Text(restaurant.name)
                            }
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Filter")
        }
    }

    private func likedCuisines() -> [String] {
        var cuisines = Set<String>()

        for fsq_id in restaurantViewModel.likedRestaurants {
            if let restaurant = restaurantViewModel.restaurants.first(where: { $0.fsq_id == fsq_id }) {
                cuisines.insert(restaurant.cuisine)
            }
        }
        return Array(cuisines)
    }

    private func filteredLikedRestaurants() -> [String] { //With help from ChatGPT
        let filteredRestaurants = restaurantViewModel.likedRestaurants.filter { fsq_id in
            guard let restaurant = restaurantViewModel.restaurants.first(where: { $0.fsq_id == fsq_id }) else {
                return false
            }

            let matchesSearchText = searchText.isEmpty || restaurant.name.localizedCaseInsensitiveContains(searchText)
            let matchesSelectedCuisine = filterViewModel.selectedCuisine == nil || (restaurant.cuisine == filterViewModel.selectedCuisine)

            return matchesSearchText && matchesSelectedCuisine
        }

        return filteredRestaurants
    }
}

struct FilterView_Previews: PreviewProvider {
        static var previews: some View {
            FilterView()
                .environmentObject(RestaurantViewModel())
                .environmentObject(FilterViewModel())
        }
    }
