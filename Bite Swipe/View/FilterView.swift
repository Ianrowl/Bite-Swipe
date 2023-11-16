//
//  FilterView.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 11/16/23.
//

import SwiftUI

struct FilterView: View {
    @ObservedObject var viewModel = FilterViewModel()
    @State private var showMapMessage = false

    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    // Toggle the showMapMessage variable
                    showMapMessage.toggle()
                }) {
                    Text("Show Filter")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                if showMapMessage {
                    Text("Filter")
                        .font(.title)
                        .padding()
                }
            }
            .padding()
            .navigationTitle("Filter") // Set the title for the navigation bar
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
    }
}

