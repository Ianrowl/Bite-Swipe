//
//  SettingsView.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 12/13/23.
//

import Foundation
import SwiftUI
import Kingfisher
import MapKit

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var restaurantViewModel: RestaurantViewModel
    @EnvironmentObject var filterViewModel: FilterViewModel
    @EnvironmentObject var mapViewModel: MapViewModel
    
//    var restaurant: Restaurant
    
    var body: some View {
        ZStack{
            Color("BKColor")
                .ignoresSafeArea()
            VStack{
                TextField("Enter Zip Code", text: $restaurantViewModel.zipCodeInput, onCommit: {
                    restaurantViewModel.fetchRestaurants()
                })
                //                    Button(action: {
                //                        restaurantViewModel.fetchRestaurants()
                //                    }) {
                //                        Text("Submit")
                //                            .font(.headline)
                //                            .foregroundColor(.white)
                //                            .padding(10)
                //                            .background(Color.blue)
                //                            .cornerRadius(10)
                //                    }

                .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Swipe Right to _Favorite_ an app")
                    .foregroundColor(Color("Accent2"))
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding(5)
                    .padding(.horizontal, 20)
                Text("Swipe Left to _Trash_ an app")
                    .foregroundColor(Color("Accent2"))
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding(5)
                    .padding(.horizontal, 20)
                Text("Filter through favorites on the **Favorites** tab")
                    .foregroundColor(Color("Accent2"))
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding(5)
                    .padding(.horizontal, 20)
                Text("And change your zip code, re-read the tutorial, and start from scratch in settings")
                    .foregroundColor(Color("Accent2"))
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding(5)
                    .padding(.horizontal, 20)
            }
        }
        
    }
}
