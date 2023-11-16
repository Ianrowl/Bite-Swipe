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
        NavigationView {
            VStack {

                if viewModel.restaurants.isEmpty {
                    ProgressView("Loading restaurants...")
                } else {
                    TextField("Enter Zip Code", text: $viewModel.zipCodeInput, onCommit: {
                        viewModel.fetchRestaurants()
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: {
                        viewModel.fetchRestaurants()
                    }) {
                        Text("Submit")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    RestaurantCard(restaurant: viewModel.restaurants[currentIndex])
                        .gesture(
                            DragGesture()
                                .onEnded { gesture in

                                    if gesture.translation.width < -70 {
                                        withAnimation {
                                            currentIndex = (currentIndex - 1 + viewModel.restaurants.count) % viewModel.restaurants.count
                                        }
                                    } else if gesture.translation.width > 70 {
                                        withAnimation {
                                            currentIndex = (currentIndex + 1) % viewModel.restaurants.count
                                        }
                                    }
                                }
                        )
                        .padding(15)
                }
            }
            .frame(maxHeight: .infinity)
            .navigationTitle("Restaurants") // Set the title for the navigation bar
            .onAppear {
                viewModel.fetchRestaurants()
            }
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
            Text("fsq_id: \(restaurant.fsq_id)")

            Text("Cuisine: \(restaurant.cuisine)")
                .padding(10)
            Text("Location: \(restaurant.location)")
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(moonGray)
        .cornerRadius(10)
//        .shadow(radius: 5)
    }
}


struct RestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantView()
    }
}

