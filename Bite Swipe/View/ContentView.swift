//
//  ContentView.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 12/13/23.
//

import Foundation
import SwiftUI

extension UserDefaults {
    var welcomeScreen: Bool {
        get {
            return (UserDefaults.standard.value(forKey: "welcomeScreen") as? Bool) ?? false
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "welcomeScreen")
        }
    }
}

struct ContentView: View {
        
    var body: some View {
        if UserDefaults.standard.welcomeScreen {
            HomeScreen()
        } else {
            WelcomeScreen()
        }
    }
}

struct WelcomeScreen: View {
    
    @State private var navigateToHomeScreen = false
    
    var body: some View {
        ZStack {
            Color("BKColor").edgesIgnoringSafeArea(.all)

            VStack {
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

                Button(action: {
                    UserDefaults.standard.set(true, forKey: "welcomeScreen")
                    navigateToHomeScreen = true
                }) {
                    VStack{
                        // Image("Image")
                        Text("**Tap to Continue**")
                            .foregroundColor(Color("Accent2"))
                            .font(.title2)
                            .padding(10)
                            .background(Color("Accent1"))
                            .cornerRadius(10)
                            .shadow(color: Color("Accent2").opacity(0.4), radius: 6, x: 0, y: 5)
                    }
                    .padding(.top, 25)                }
                .background(Color("BKColor"))
            }
        }
        .onAppear(perform: {
            UserDefaults.standard.welcomeScreen = true
        })
        .fullScreenCover(isPresented: $navigateToHomeScreen) {
            HomeScreen()
        }
    }
}

struct HomeScreen: View {
    @State private var selectedTab = 0
    @ObservedObject var restaurantViewModel = RestaurantViewModel()
    @ObservedObject var filterViewModel = FilterViewModel()
    @StateObject var mapViewModel = MapViewModel()

    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                RestaurantView()
                    .environmentObject(restaurantViewModel)
                    .tabItem {
                        Image(systemName: "fork.knife.circle")
                        Text("Discover")
                    }
                    .tag(0)

                FilterView()
                    .environmentObject(filterViewModel)
                    .tabItem {
                        Image(systemName: "slider.horizontal.3")
                        Text("Favorites")
                    }
                    .tag(1)
            }
            .environmentObject(restaurantViewModel)
            .environmentObject(filterViewModel)
            .environmentObject(mapViewModel)
        }
    }
}
