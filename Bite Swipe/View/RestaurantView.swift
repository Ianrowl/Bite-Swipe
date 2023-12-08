//
//  RestaurantView.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 11/2/23.
//

import SwiftUI
import Kingfisher
import Combine

struct RestaurantView: View {
    @EnvironmentObject var restaurantViewModel: RestaurantViewModel
    @EnvironmentObject var filterViewModel: FilterViewModel
    @State private var currentRestaurantID: String?
    
    var body: some View {
        NavigationView {
            VStack {

                if restaurantViewModel.restaurants.isEmpty {
                    ProgressView("Loading restaurants...")
                } else {
                    TextField("Enter Zip Code", text: $restaurantViewModel.zipCodeInput, onCommit: {
                        restaurantViewModel.fetchRestaurants()
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        restaurantViewModel.fetchRestaurants()
                    }) {
                        Text("Submit")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    RestaurantCard(currentPhotoIndex: $restaurantViewModel.currentPhotoIndex, currentRestaurantID: $currentRestaurantID, restaurant: restaurantViewModel.restaurants[restaurantViewModel.currentIndex])
                        .gesture(
                            DragGesture()
                                .onEnded { gesture in
                                    withAnimation {
                                        if gesture.translation.width < -70 {
                                            restaurantViewModel.currentIndex = (restaurantViewModel.currentIndex + 1) % restaurantViewModel.restaurants.count
                
                                            restaurantViewModel.dislikeRestaurant(restaurantViewModel.restaurants[restaurantViewModel.currentIndex].fsq_id)
                                            
                                            
                                        } else if gesture.translation.width > 70 {
                                            restaurantViewModel.currentIndex = (restaurantViewModel.currentIndex + 1) % restaurantViewModel.restaurants.count
                                            restaurantViewModel.likeRestaurant(restaurantViewModel.restaurants[restaurantViewModel.currentIndex-1].fsq_id)
                                            
                                        }
                                    }
                                    currentRestaurantID = restaurantViewModel.restaurants[restaurantViewModel.currentIndex].fsq_id
                                }
                        )
                        .padding(15)
                }
            }
            .frame(maxHeight: .infinity)
            .navigationTitle("Restaurants") // Set the title for the navigation bar
            .onAppear {
                restaurantViewModel.fetchRestaurants()
            }
        }


    }
}



struct RestaurantCard: View {
    
    let moonGray = Color(white: 0.9, opacity: 0.7) // Found this color
    @EnvironmentObject var restaurantViewModel: RestaurantViewModel
    
    @Binding var currentPhotoIndex: Int
    @Binding var currentRestaurantID: String?
    
    var restaurant: Restaurant
    
    var body: some View {
        VStack {
            Text(restaurant.name)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding(20)
            if restaurantViewModel.photos.isEmpty {
                PlaceholderView()
                    .frame(width: 200, height: 250)
                    .cornerRadius(10)

            } else {
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
            }

            
            Text("Cuisine: \(restaurant.cuisine)")
                .padding(5)
            
            Text("Location: \(restaurant.location)")
                .multilineTextAlignment(.center)

                .padding(15)
            
            Spacer()
        }
        .onAppear {
            restaurantViewModel.fetchPhotos(for: restaurant)
        }
        .onChange(of: restaurant) { _, _ in
//            restaurantViewModel.selectedPhoto = restaurantViewModel.photos.randomElement()
            restaurantViewModel.resetPhotos()

            restaurantViewModel.fetchPhotos(for: restaurant)
        }

        .frame(maxWidth: .infinity)
        .background(moonGray)
        .cornerRadius(10)
    }
}

struct PlaceholderView: View {
    var body: some View {
        Rectangle()
            .foregroundColor(Color.gray.opacity(0.5))
    }
}
//struct RestaurantView_Previews: PreviewProvider {
//    static var previews: some View {
//        RestaurantView()
//            .environmentObject(RestaurantViewModel())  // Provide an instance of RestaurantViewModel
//            .environmentObject(FilterViewModel())      // Provide an instance of FilterViewModel
//    }
//}

