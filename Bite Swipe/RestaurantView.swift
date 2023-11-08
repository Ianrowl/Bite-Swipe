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
                    .font(.title)
                    .padding(10)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)//Centers the text (ChatGPT assisted)
                
                Text("Cuisine: \(restaurant.cuisine)")
                    .padding(10)
                Text("Location: \(restaurant.location)")
                    .padding(10)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
//            .frame(maxHeight: .infinity)
            .background(Color.blue)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding()
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



