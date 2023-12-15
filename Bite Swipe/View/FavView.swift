//
//  FavView.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 12/7/23.
//

import Foundation
import SwiftUI
import Kingfisher
import MapKit

struct FavView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var restaurantViewModel: RestaurantViewModel
    @EnvironmentObject var filterViewModel: FilterViewModel
    @EnvironmentObject var mapViewModel: MapViewModel
    
    var restaurant: Restaurant
    
    var body: some View {
        ZStack{
            Color("BKColor")
                .ignoresSafeArea()
            
            VStack {
                Text(restaurant.name)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding(20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(restaurantViewModel.photos, id: \.id) { photo in
                            KFImage.url(restaurantViewModel.createPhotoURL(photo: photo))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 250)
                                .cornerRadius(10)
                        }
                    }
                }
                
                Text("Cuisine: \(restaurant.cuisine)")
                    .padding(10)
                
                Button(action: {
                    filterViewModel.selectedRestaurant = restaurant
                    filterViewModel.isModalPresented.toggle()
                }) {
                    Text("Map")
                }
                .padding()
                .sheet(isPresented: $filterViewModel.isModalPresented) {
                    if let selectedRestaurant = filterViewModel.selectedRestaurant {
                        ModalSheet(restaurant: selectedRestaurant)
                            .environmentObject(mapViewModel)
                    }
                }
                
                .onAppear {
                    restaurantViewModel.resetPhotos()
                    
                    restaurantViewModel.fetchPhotos(for: restaurant)
                }
            }
            .background(Color("BKColor"))
        }
    }
}

struct ModalSheet: View {
    @EnvironmentObject var mapViewModel: MapViewModel
    var restaurant: Restaurant
    @Environment(\.dismiss) var dismiss
    
    @State private var showAllRestaurants = false

    var body: some View {
        ZStack{
            Color("BKColor")
                .ignoresSafeArea()
            VStack {
                Button("Close") {
                    dismiss()
                }
                .padding()
                
                Map {
                    ForEach([restaurant], id: \.id) { restaurant in
                        Annotation(restaurant.name, coordinate: CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)) {
                            NavigationLink {
                                FavView(restaurant: restaurant)
                            } label: {
                                Image("BiteSwipeMarker")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60, alignment: .top)
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
            }
            .padding()
            .background(Color("BKColor"))
        }
    }
}

