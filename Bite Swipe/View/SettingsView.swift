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
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
        
    }
}
