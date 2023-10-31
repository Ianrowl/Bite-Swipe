//
//  HomeViewModel.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 10/26/23.
//
import Foundation
import SwiftUI
class HomeViewModel: ObservableObject {
    @Published var showMessage = false
    
    func toggleMessage() {
        showMessage.toggle()
    }
}
