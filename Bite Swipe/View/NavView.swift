//
//  NavView.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 11/16/23.
//

import SwiftUI
import Kingfisher

struct NavView: View {
    @State private var selectedTab = 0
    @ObservedObject var restaurantViewModel = RestaurantViewModel()
    @ObservedObject var filterViewModel = FilterViewModel()

    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                RestaurantView()
                    .environmentObject(restaurantViewModel)
                    .tabItem {
                        Image(systemName: "fork.knife.circle")
                        Text("Restaurants")
                    }
                    .tag(0)

                FilterView()
                    .environmentObject(filterViewModel)
                    .tabItem {
                        Image(systemName: "slider.horizontal.3")
                        Text("Filters")
                    }
                    .tag(1)
            }
            .environmentObject(restaurantViewModel)
            .environmentObject(filterViewModel)
        }
    }
}

struct ModalSheet: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var restaurantViewModel: RestaurantViewModel
    
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
            
            NavigationLink(destination: MapView()) {
                Text("Restaurant: \(restaurant.name)")
            }
 
        }
        .padding()
        .onAppear {
            restaurantViewModel.resetPhotos()
            restaurantViewModel.fetchPhotos(for: restaurant)
        }
    }
}

//struct NavView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavView()
//            .environmentObject(RestaurantViewModel())  // Provide an instance of RestaurantViewModel... From ChatGPT help
//            .environmentObject(FilterViewModel())
//    }
//}
