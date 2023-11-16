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
//    let skyBlue = Color(red: 0.4627, green: 0.8392, blue: 1.0)
    
    var body: some View {
        VStack {
            TextField("Enter Zip Code", text: $viewModel.zipCodeInput, onCommit: {
                  viewModel.fetchRestaurants()
              })
              .textFieldStyle(RoundedBorderTextFieldStyle())
//                      .padding()
            Button(action: {
                viewModel.fetchRestaurants()
            }) {
                Text("Submit")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(10)
    //                        .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            if viewModel.restaurants.isEmpty {
                ProgressView("Loading restaurants...")
            } else {
                RestaurantCard(restaurant: viewModel.restaurants[currentIndex])
                    .gesture(
                        DragGesture()
                            .onEnded { gesture in
                                if gesture.translation.width > 70 {
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


