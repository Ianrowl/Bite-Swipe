//
//  MapViewModel.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 11/16/23.
//

import Foundation
import MapKit

class MapViewModel: ObservableObject {
    @Published var centerCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()

}
