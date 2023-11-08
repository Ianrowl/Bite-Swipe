//
//  RestaurantView.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 11/2/23.
//

import SwiftUI

struct RestaurantView: View {
    @ObservedObject var viewModel = RestaurantViewModel()

    var body: some View {
        List(viewModel.restaurants, id: \.name) { restaurant in
            VStack(alignment: .leading) {
                Text(restaurant.name)
                    .font(.headline)
                Text("Cuisine: \(restaurant.cuisine)")
                Text("Location: \(restaurant.location)")
            }
        }
        .onAppear {
            viewModel.fetchRestaurants()
            }
        }
    }

struct RestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantView()
    }
}



