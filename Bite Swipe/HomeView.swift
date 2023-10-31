//
//  HomeView.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 10/26/23.
//
import SwiftUI
struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    var body: some View {
        VStack {
            if viewModel.showMessage {
                Text("Welcome to Bite Swipe")
                    .font(.largeTitle)
                    .padding()
            } else {
                Button(action: {
                    self.viewModel.toggleMessage()
                }) {
                    Text("Show Welcome Message")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
