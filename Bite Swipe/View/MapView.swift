//
//  MapView.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 11/16/23.
//

import Foundation
import SwiftUI

struct MapView: View {
        
        @ObservedObject var viewModel = FilterViewModel()
        @State private var showMapMessage = false
        
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    // Toggle the showMapMessage variable
                    showMapMessage.toggle()
                }) {
                    Text("Show Map")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                if showMapMessage {
                    Text("MAP")
                        .font(.title)
                        .padding()
                }
            }
            .padding()
            .navigationTitle("Map") // Set the title for the navigation bar
        }
    }
    }
    
    struct MapView_Previews: PreviewProvider {
        static var previews: some View {
            MapView()
        }
    }
