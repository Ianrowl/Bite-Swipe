//
//  RestaurantView.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 11/2/23.
//

import SwiftUI

struct RestaurantView: View {
    @ObservedObject var viewModel = RestaurantViewModel()
    @State private var currentIndex = 0
    
    var body: some View {
        VStack {
            if viewModel.restaurants.isEmpty {
                ProgressView("Loading restaurants...")
            } else {
                RestaurantCard(restaurant: viewModel.restaurants[currentIndex])
                    .onTapGesture {
                        withAnimation {
                            currentIndex = (currentIndex + 1) % viewModel.restaurants.count //Cycles continuously for now, will have it stop or reset in the future.
                        }
                    }
                    .padding()
            }
        }
        .frame(maxHeight: .infinity)
//        .background(Color.black)
        .onAppear {
            viewModel.fetchRestaurants()
        }
    }
}


struct RestaurantCard: View {
    let moonGray = Color(white: 0.9, opacity: 0.7) //Found this color

    let restaurant: Restaurant
    
    var body: some View {
        VStack {
            Text(restaurant.name)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding(50)
            Text("Cuisine: \(restaurant.cuisine)")
            Text("Location: \(restaurant.location)")
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(moonGray)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}


struct RestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantView()
    }
}






