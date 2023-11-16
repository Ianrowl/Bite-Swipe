//
//  NavView.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 11/16/23.
//

import SwiftUI

struct NavView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            MapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
                .tag(0)

            RestaurantView()
                .tabItem {
                    Image(systemName: "fork.knife.circle")
                    Text("Restaurants")
                }
                .tag(1)

            FilterView()
                .tabItem {
                    Image(systemName: "slider.horizontal.3")
                    Text("Filters")
                }
                .tag(2)

        }
    }
}

struct NavView_Previews: PreviewProvider {
    static var previews: some View {
        NavView()
    }
}
