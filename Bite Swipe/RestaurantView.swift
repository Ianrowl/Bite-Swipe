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
        NavigationView {
            List(viewModel.restaurants, id: \.name) { restaurant in
                VStack(alignment: .leading) {
                    Text(restaurant.name)
                    Text(restaurant.address)
                        .font(.subheadline)
                }
            }
            .navigationBarTitle("Restaurants")
            .onAppear {
                viewModel.fetchRestaurants()
            }
        }
    }
}

struct RestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantView(viewModel: RestaurantViewModel())
    }
}
