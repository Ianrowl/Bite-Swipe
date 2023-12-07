//
//  NavView.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 11/16/23.
//

import SwiftUI
import Kingfisher
import MapKit

struct NavView: View {
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

struct ModalSheet: View {
    @EnvironmentObject var mapViewModel: MapViewModel
    var restaurant: Restaurant
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Map()
        Button("Close") {
            dismiss()
        }
        .padding()
    }
}

//struct NavView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavView()
//            .environmentObject(RestaurantViewModel())  // Provide an instance of RestaurantViewModel... From ChatGPT help
//            .environmentObject(FilterViewModel())
//    }
//}
