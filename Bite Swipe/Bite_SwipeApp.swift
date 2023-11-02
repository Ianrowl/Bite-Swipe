//
//  Bite_SwipeApp.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 10/26/23.
//
import SwiftUI
@main
struct Bite_SwipeApp: App {
    @StateObject var viewModel = HomeViewModel()
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: viewModel)
        }
    }
}

//@main
//struct Bite_SwipeApp: App {
//    @StateObject var restaurantViewModel = RestaurantViewModel()
//
//    var body: some Scene {
//        WindowGroup {
//            HomeView()
//                .environmentObject(restaurantViewModel)
//        }
//    }
//}
