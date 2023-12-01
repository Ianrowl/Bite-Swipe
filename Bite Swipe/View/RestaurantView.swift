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
    @State private var currentIndex = 0
    @State private var currentPhotoIndex = 0
    @State private var currentRestaurantID: String?
    
//    var restaurant: Restaurant

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
                    
                    RestaurantCard(currentPhotoIndex: $currentPhotoIndex, currentRestaurantID: $currentRestaurantID, restaurant: restaurantViewModel.restaurants[currentIndex])
                        .gesture(
                            DragGesture()
                                .onEnded { gesture in
                                    withAnimation {
                                        if gesture.translation.width < -70 {
                                            currentIndex = (currentIndex - 1 + restaurantViewModel.restaurants.count) % restaurantViewModel.restaurants.count
                
                                            restaurantViewModel.dislikeRestaurant(restaurantViewModel.restaurants[currentIndex].fsq_id)
                                            
                                            
                                        } else if gesture.translation.width > 70 {
                                            currentIndex = (currentIndex + 1) % restaurantViewModel.restaurants.count
                                            restaurantViewModel.likeRestaurant(restaurantViewModel.restaurants[currentIndex-1].fsq_id)
                                            
                                        }
                                    }
                                    currentRestaurantID = restaurantViewModel.restaurants[currentIndex].fsq_id
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
    

    @State private var selectedPhoto: Photo?
    @State private var photos: [Photo] = []

    
    @Binding var currentPhotoIndex: Int
    @Binding var currentRestaurantID: String?
    
    var restaurant: Restaurant
    var body: some View {
        VStack {
            Text(restaurant.name)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding(20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(photos, id: \.id) { photo in
                        KFImage.url(createPhotoURL(photo: photo))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 150) // Adjust the width and height as needed
                            .cornerRadius(10)
                    }
                }
            }
            
            Text("Cuisine: \(restaurant.cuisine)")
                .padding(10)
//            Text("ID: \(restaurant.fsq_id)")
                .padding(10)
            
            Text("Location: \(restaurant.location)")
            
            Spacer()
        }
        .onAppear {
            fetchPhotos(for: restaurant)
        }
        .onChange(of: restaurant) { _, _ in
//            selectedPhoto = photos.randomElement()
            selectedPhoto = photos.randomElement()
            fetchPhotos(for: restaurant)
            
        }

        .frame(maxWidth: .infinity)
        .background(moonGray)
        .cornerRadius(10)
    }
    
    private func createPhotoURL(photo: Photo) -> URL {
        let urlString = "\(photo.prefix)original\(photo.suffix)" // You can modify the size as needed
        return URL(string: urlString)!
    }
    
    func fetchPhotos(for restaurant: Restaurant) {
        selectedPhoto = photos.randomElement()

        RestaurantService().fetchPhotos(venueID: restaurant.fsq_id) { result in
            switch result {
            case .success(let fetchedPhotos):
                DispatchQueue.main.async {
                    if let fetchedPhotos = fetchedPhotos, !fetchedPhotos.isEmpty {
                        self.photos = fetchedPhotos
                    } else {
                        self.photos = []
                    }
                }
            case .failure(let error):
                print("Error fetching photos: \(error)")
            }
        }
    }
}

//struct RestaurantView_Previews: PreviewProvider {
//    static var previews: some View {
//        RestaurantView()
//            .environmentObject(RestaurantViewModel())  // Provide an instance of RestaurantViewModel
//            .environmentObject(FilterViewModel())      // Provide an instance of FilterViewModel
//    }
//}
