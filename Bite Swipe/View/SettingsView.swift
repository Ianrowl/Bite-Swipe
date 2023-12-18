//
//  SettingsView.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 12/13/23.
//

import Foundation
import SwiftUI
import Kingfisher
import MapKit

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var restaurantViewModel: RestaurantViewModel
    @EnvironmentObject var filterViewModel: FilterViewModel
    @EnvironmentObject var mapViewModel: MapViewModel
    
    @State private var isTutorialPresented = false
    @State private var isResetConfirmationPresented = false
    
    @State private var showAlert = false
    @State private var alertMessage = ""
        
    var body: some View {
        ZStack{
            Color("BKColor")
                .ignoresSafeArea()
            VStack{
                Text("Settings")
                    .font(Font.custom("PlayfairDisplay-Bold", size: 38, relativeTo: .title))
                Spacer()

                HStack {
                    TextField("Enter Zip Code", text: $restaurantViewModel.zipCodeInput, onCommit: {
                        if restaurantViewModel.isValidZipCode(restaurantViewModel.zipCodeInput) {
                            restaurantViewModel.fetchRestaurants { success in
                                if success {
                                    restaurantViewModel.currentZipCode = restaurantViewModel.zipCodeInput
                                    UserDefaults.standard.set(restaurantViewModel.zipCodeInput, forKey: restaurantViewModel.publicZipCodeKey)
                                } else {
                                    alertMessage = "Error fetching restaurants. Please try again."
                                    showAlert = true
                                }
                            }
                        } else {
                            alertMessage = "Invalid zip code. Please enter a valid zip code."
                            showAlert = true
                        }
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(Font.custom("EBGaramond-Medium", size: 20, relativeTo: .subheadline))
                    .shadow(color: Color("Accent2").opacity(0.2), radius: 3, x: 0, y: 3)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color("Accent2"), lineWidth: 0.5)
                    )
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Error"),
                            message: Text(alertMessage),
                            dismissButton: .default(Text("OK")) {
                                showAlert = false
                            }
                        )
                    }
             
                    Button(action: {
                        restaurantViewModel.fetchRestaurants { success in
                            if success {
                                restaurantViewModel.currentZipCode = restaurantViewModel.zipCodeInput
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) // Dismisses the keyboard
                            } else {
                                alertMessage = "Error fetching restaurants. Please try again."
                                showAlert = true
                            }
                        }
                    }) {
                        Text("Submit")
                            .font(Font.custom("EBGaramond-Bold", size: 20, relativeTo: .body))
                            .foregroundColor(Color("Accent2"))
                            .padding(5)
                            .background(Color("Accent1"))
                            .cornerRadius(10)
                            .shadow(color: Color("Accent2").opacity(0.3), radius: 3, x: 0, y: 3)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("Accent2"), lineWidth: 0.5) // Set the border color and width
                            )
                    }

                }.padding(.horizontal, 15)

                
                Text("**Current Zip Code:** \(restaurantViewModel.currentZipCode)")
                    .foregroundColor(Color("Accent2"))
                    .font(Font.custom("EBGaramond-Medium", size: 25, relativeTo: .body))
                    .padding(10)

                
                Button(action: {
                    isTutorialPresented.toggle()
                }) {
                    VStack{
                        Text("_Tutorial_")
                            .foregroundColor(Color("Accent2"))
                            .font(Font.custom("EBGaramond-Medium", size: 22, relativeTo: .body))
                            .padding(7)
                            .background(Color("Accent1"))
                            .cornerRadius(5)
                            .shadow(color: Color("Accent2").opacity(0.4), radius: 5, x: 0, y: 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color("Accent2"), lineWidth: 1)
                            )
                    }
                    .padding(.top, 25)
                    .padding(.bottom, 50)
                    
                }
                .sheet(isPresented: $isTutorialPresented) {
                    TutorialView()
                }
                
                Button(action: {
                    isResetConfirmationPresented.toggle()
                }) {
                    Text("Reset App")
                        .font(Font.custom("EBGaramond-Bold", size: 42, relativeTo: .title))
                        .foregroundColor(Color("Accent1"))
                        .padding(60)
                        .padding(.horizontal, 40)
                        .background(Color("Reset"))
                        .cornerRadius(20)
                        .shadow(color: Color("Accent2").opacity(0.4), radius: 7, x: 2, y: 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color("Accent1"), lineWidth: 2)
                        )
                }
                .alert(isPresented: $isResetConfirmationPresented) {
                    Alert(
                        title: Text("Confirm Reset"),
                        message: Text("Are you sure you want to reset the app? This will clear all data, including the zip code and liked/disliked restaurants."),
                        primaryButton: .default(Text("Reset"), action: {
                            restaurantViewModel.resetApp()
                        }),
                        secondaryButton: .cancel()
                    )
                }
                .padding(.bottom, 50)

                Spacer()

            }
        }
        .onAppear {
            // Load the last entered zip code from UserDefaults when the view appears
            if let lastEnteredZipCode = UserDefaults.standard.string(forKey: restaurantViewModel.publicZipCodeKey) {
                restaurantViewModel.zipCodeInput = lastEnteredZipCode
            }
        }
        
    }
}

struct TutorialView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack{
            Color("BKColor")
                .ignoresSafeArea()
            VStack {
                Button(action: {
                    dismiss()
                }) {
                    Text("Close")
                        .font(Font.custom("EBGaramond-Bold", size: 20, relativeTo: .subheadline))
                        .foregroundColor(Color("Accent3"))
                }.padding(10)
                Spacer()
                
                Text("Swipe right to **Favorite** a restaurant")
                    .foregroundColor(Color("Accent2"))
                    .font(Font.custom("EBGaramond-Medium", size: 24, relativeTo: .title3))
                    .multilineTextAlignment(.center)
                    .padding(5)
                    .padding(.horizontal, 20)
                Text("Swipe left to **Trash** a restaurant")
                    .foregroundColor(Color("Accent2"))
                    .font(Font.custom("EBGaramond-Medium", size: 24, relativeTo: .title3))
                    .multilineTextAlignment(.center)
                    .padding(5)
                    .padding(.horizontal, 20)
                Text("For long restaurant names, click on them to view the whole name")
                    .foregroundColor(Color("Accent2"))
                    .font(Font.custom("EBGaramond-Medium", size: 24, relativeTo: .title3))
                    .multilineTextAlignment(.center)
                    .padding(5)
                    .padding(.horizontal, 20)
                Text("Filter through favorites on the **Favorites** tab")
                    .foregroundColor(Color("Accent2"))
                    .font(Font.custom("EBGaramond-Medium", size: 24, relativeTo: .title3))
                    .multilineTextAlignment(.center)
                    .padding(5)
                    .padding(.horizontal, 20)
                Spacer()

            }
        }
    }
}
