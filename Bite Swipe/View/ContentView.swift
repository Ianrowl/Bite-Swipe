//
//  ContentView.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 12/13/23.
//

import Foundation

struct ContentView: View {
    @State private var selectedTab = 0
    @ObservedObject var restaurantViewModel = RestaurantViewModel()
    @ObservedObject var filterViewModel = FilterViewModel()
    @StateObject var mapViewModel = MapViewModel()

    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                RestaurantView()
                    .environmentObject(restaurantViewModel)
                    .tabItem {
                        Image(systemName: "fork.knife.circle")
                        Text("Restaurants")
                    }
                    .tag(0)

                FilterView()
                    .environmentObject(filterViewModel)
                    .tabItem {
                        Image(systemName: "slider.horizontal.3")
                        Text("Filters")
                    }
                    .tag(1)
            }
            .environmentObject(restaurantViewModel)
            .environmentObject(filterViewModel)
            .environmentObject(mapViewModel)
        }
    }
}
