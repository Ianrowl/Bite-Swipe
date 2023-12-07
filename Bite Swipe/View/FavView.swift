//
//  FavView.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 12/7/23.
//

import Foundation
import SwiftUI
import Kingfisher

struct FavView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var restaurantViewModel: RestaurantViewModel
    @EnvironmentObject var filterViewModel: FilterViewModel
    @EnvironmentObject var mapViewModel: MapViewModel
    
    var restaurant: Restaurant
    
    var body: some View {
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
    }
}
