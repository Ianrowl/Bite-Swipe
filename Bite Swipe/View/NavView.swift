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
    
    @State private var showAllRestaurants = false

    var body: some View {
        Map {
            ForEach([restaurant], id: \.id) { restaurant in //Help from Josh's code and GPT
                Annotation(restaurant.name, coordinate: CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)) {
                    NavigationLink {
                        FavView(restaurant: restaurant)
                    } label: {
                        Image("BiteSwipeMarker")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .shadow(radius: 60)
                    }
                }
            }
        }
        .onAppear {
            mapViewModel.centerCoordinate = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
        }
        .mapStyle(.imagery(elevation: .realistic))
        .mapControls {
            MapUserLocationButton()
            MapCompass()
        }
        
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
