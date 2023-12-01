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
                        Text("Italian").tag("Italian")
                        Text("Mexican").tag("Mexican")
                        // Add more cuisine options as needed
                    }
                    .pickerStyle(WheelPickerStyle())
                }

                Section(header: Text("Liked Restaurants")) {
                    Text("Debug Info")
                        .onAppear {
                            print("Liked Restaurants IDs: \(restaurantViewModel.likedRestaurants)")
                            print("Liked Restaurants Names:")
                            for fsq_id in restaurantViewModel.likedRestaurants {
                                if let restaurant = restaurantViewModel.restaurants.first(where: { $0.fsq_id == fsq_id }) {
                                    print(restaurant.name)
                                }
                            }
                        }

                    if restaurantViewModel.likedRestaurants.isEmpty {
                        Text("No liked restaurants found.")
                    } else {
                        ForEach(restaurantViewModel.likedRestaurants, id: \.self) { fsq_id in
                            if let restaurant = restaurantViewModel.restaurants.first(where: { $0.fsq_id == fsq_id }) {
                                Text(restaurant.name)
                                    // Add any additional styling or formatting here
                            }
                        }
                    }
                }
            }
            .navigationTitle("Filter")
        }
    }
}


struct FilterView_Previews: PreviewProvider {
        static var previews: some View {
            FilterView()
                .environmentObject(RestaurantViewModel())  // Provide an instance of RestaurantViewModel
                .environmentObject(FilterViewModel())      // Provide an instance of FilterViewModel
        }
    }
