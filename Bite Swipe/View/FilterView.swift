//
//  FilterView.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 11/16/23.
//

import SwiftUI
import UIKit

struct FilterView: View {
    @EnvironmentObject var filterViewModel: FilterViewModel
    @EnvironmentObject var restaurantViewModel: RestaurantViewModel
    @EnvironmentObject var mapViewModel: MapViewModel
    
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("BKColor")
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    Form {
                        Section(header: Text("Search")) {
                            TextField("Search", text: $searchText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
//                                .background(Color("Accent1"))
                                .accentColor(Color("Accent1")) // Replace with your desired color
//                                .foregroundColor(Color("Accen1"))
                            
                            
                            Picker("Select Cuisine", selection: $filterViewModel.selectedCuisine) {
                                Text("All Cuisines").tag(nil as String?)
                                ForEach(likedCuisines().sorted(), id: \.self) { cuisine in
                                    Text(cuisine).tag(cuisine as String?)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(height: 120)
                        }.listRowBackground(Color("Accent1"))
                        
                        Section(header: Text("Favorited Restaurants")) {
                            if restaurantViewModel.likedRestaurants.isEmpty {
                                Text("No liked restaurants found.")
                                    .listRowBackground(Color("Accent1"))
                            } else {
                                ForEach(filteredLikedRestaurants(), id: \.self) { fsq_id in
                                    if let restaurant = restaurantViewModel.restaurants.first(where: { $0.fsq_id == fsq_id }) {
                                        NavigationLink(destination: FavView(restaurant: restaurant)) {
                                            Text(restaurant.name)
                                        }
                                    }
                                }.listRowBackground(Color("Accent1"))
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(GroupedListStyle())
                    .background(Color("BKColor"))
                    Spacer() // Add spacer at the bottom

                }
            }
            .navigationBarTitleDisplayMode(.inline)
              .toolbar {
                  ToolbarItem(placement: .principal) {
                      VStack {
                          Spacer()
                          Text("Favorites")
                              .font(.largeTitle.bold())
                              .foregroundColor(Color(Color("Accent2")))
                              .padding(.top, 27) // Add some bottom padding for spacing
                              .padding(.bottom, 10) // Add some bottom padding for spacing
                          Spacer()
                      }
                  }
              }
              .navigationBarItems(
                  leading: NavigationLink(destination: MapView()) {
                      Image(systemName: "map")
                          .font(.title)
                  },
                  trailing: NavigationLink(destination: SettingsView()) {
                      Image(systemName: "gear")
                          .font(.title)
                  }
              )
//            .navigationTitle("Favorites")
//            .navigationBarItems(
//                leading: NavigationLink(destination: MapView()) {
//                    Image(systemName: "map")
//                        .font(.title)
//                },
//                trailing: NavigationLink(destination: SettingsView()) {
//                    Image(systemName: "gear")
//                        .font(.title)
//                }
//            )

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

//struct FilterView_Previews: PreviewProvider {
//        static var previews: some View {
//            FilterView()
//                .environmentObject(RestaurantViewModel())  // Provide an instance of RestaurantViewModel
//                .environmentObject(FilterViewModel())      // Provide an instance of FilterViewModel
//        }
//}
