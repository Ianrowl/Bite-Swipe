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
    
    @State private var loadingTimeout = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack{
                Color("BKColor")
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    if restaurantViewModel.restaurants.isEmpty {
                        if !loadingTimeout {
                            ProgressView("Loading restaurants...")
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                                        if restaurantViewModel.restaurants.isEmpty {
                                            alertMessage = "Loading took too long. Please try a different zip code."
                                            showAlert = true
                                        }
                                    }
                                }
                        }
                    } else {
                        withAnimation {
                            
                            RestaurantCard(currentPhotoIndex: $restaurantViewModel.currentPhotoIndex, currentRestaurantID: $currentRestaurantID, restaurant: restaurantViewModel.restaurants[restaurantViewModel.currentIndex])
                                .gesture(
                                    DragGesture()
                                        .onEnded { gesture in
                                            withAnimation{
                                                if gesture.translation.width < -70 {
                                                    restaurantViewModel.currentIndex = (restaurantViewModel.currentIndex + 1) % restaurantViewModel.restaurants.count
                                                    restaurantViewModel.incrementIndex()
                                                    
                                                    restaurantViewModel.dislikeRestaurant(restaurantViewModel.restaurants[restaurantViewModel.currentIndex].fsq_id)
                                                    
                                                    
                                                } else if gesture.translation.width > 70 {
                                                    restaurantViewModel.currentIndex = (restaurantViewModel.currentIndex + 1) % restaurantViewModel.restaurants.count
                                                    restaurantViewModel.likeRestaurant(restaurantViewModel.restaurants[restaurantViewModel.currentIndex-1].fsq_id)
                                                    restaurantViewModel.incrementIndex()
                                                    
                                                }
                                            }
                                            currentRestaurantID = restaurantViewModel.restaurants[restaurantViewModel.currentIndex].fsq_id
                                        }
                                )
                                .padding(15)
                            
                        }
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK")) {
                            showAlert = false
                        }
                    )
                }
                .frame(maxHeight: .infinity)
                .navigationBarTitleDisplayMode(.inline)
                  .toolbar {
                      ToolbarItem(placement: .principal) {
                          VStack {
                              Spacer()
                              Text("Discover")
                                  .font(.largeTitle.bold())
                                  .foregroundColor(Color("Accent2"))
                                  .padding(.top, 27)
                                  .padding(.bottom, 10)
                              Spacer()
                          }
                      }
                  }
                  .navigationBarItems(
    //                  leading: NavigationLink(destination: MapView()) {
    //                      Image(systemName: "map")
    //                          .font(.title)
    //                  },
                      trailing: NavigationLink(destination: SettingsView()) {
                          Image(systemName: "gear")
                              .font(.title)
                      }
                  )                .padding(.top, 15)

                .onAppear {
                    restaurantViewModel.fetchRestaurants { success in
                        if !success {
                            // Handle the case when the API call is not successful
                            print("Error fetching restaurants. Please try again.")
                        }
                    }               
                }
            }
            
        }
    }
}



struct RestaurantCard: View {
    
    @EnvironmentObject var restaurantViewModel: RestaurantViewModel
    
    @Binding var currentPhotoIndex: Int
    @Binding var currentRestaurantID: String?
    
    @State private var cardOffset: CGSize = .zero
    
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
         .background(Color("Accent1"))
         .cornerRadius(10)
         .offset(cardOffset)
         .rotationEffect(.degrees(Double(cardOffset.width / 15)))
         .gesture(
             DragGesture()
                 .onChanged { value in
                     cardOffset.width = value.translation.width
                 }
                 .onEnded { value in
                     withAnimation (.easeInOut){
                         if value.translation.width < -70 {
                             cardOffset.width = -500 // Swipe left
                             restaurantViewModel.currentIndex = (restaurantViewModel.currentIndex + 1) % restaurantViewModel.restaurants.count
                             restaurantViewModel.dislikeRestaurant(restaurantViewModel.restaurants[restaurantViewModel.currentIndex].fsq_id)
                         } else if value.translation.width > 70 {
                             cardOffset.width = 500 // Swipe right
                             restaurantViewModel.currentIndex = (restaurantViewModel.currentIndex + 1) % restaurantViewModel.restaurants.count
                             restaurantViewModel.likeRestaurant(restaurantViewModel.restaurants[restaurantViewModel.currentIndex - 1].fsq_id)
                         } else {
                             cardOffset = .zero
                         }
                     }
                     
                     withAnimation {
                         cardOffset = .zero
                     }
                 }
         )
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

