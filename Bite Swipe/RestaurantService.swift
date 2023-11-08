//
//  RestaurantService.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 11/2/23.
//

import Foundation

class RestaurantService {
//    private let apiURL = "https://api.foursquare.com/v3/places/search"
//    private let apiURL = "https://api.foursquare.com/v3/places/search?near=Boulder,Colorado&limit=25"
    private let apiURL = "https://api.foursquare.com/v3/places/search?radius=24000&limit=25"//Will likely keep editing this as the project goes on



    private let apiKey = "fsq3kl7NeyCzFZSmIzk4VZaT3iww2HUeylc4XB3NA/crDPA="

    func fetchRestaurants(completion: @escaping ([Restaurant]?) -> Void) {
        guard let url = URL(string: apiURL) else {
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Response.self, from: data)
                    let restaurants = response.results.map { result in
                        return Restaurant(
                            name: result.name,
                            cuisine: result.categories.first?.name ?? "",
                            location: result.location.formatted_address
                        )
                    }
                    completion(restaurants)
                } catch {
                    print("Error parsing JSON: \(error)")
                    completion(nil)
                }
            }
        }.resume()
    }
}

private struct Response: Decodable {
    let results: [Result]
}

private struct Result: Decodable {
    let name: String
    let categories: [Category]
    let location: Location
    let photo: Photo? // Add a property for the photo data

    // Define the Photo struct
    struct Photo: Decodable {
        let url: String
    }
}


//private struct Result: Decodable {
//    let name: String
//    let categories: [Category]
//    let location: Location
//}

private struct Category: Decodable {
    let name: String
}

private struct Location: Decodable {
    let formatted_address: String
}


