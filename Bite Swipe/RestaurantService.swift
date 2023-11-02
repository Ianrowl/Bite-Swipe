//
//  RestaurantService.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 11/2/23.
//

import Foundation

class RestaurantService {
    static let shared = RestaurantService()

    private let apiURL = URL(string: "https://api.foursquare.com/v3/places/search")!
    private let apiKey = "FQ5NHUYD3MUSFD1B5Y0JQ1EZFXV4AUM3FEMN3ERBMDF05NW4"
    private let apiSecret = "M3IPC4A023HPGJ4AARLU1VZIVHCG1540FIZRE0PHHQTRSZ5I"
    private let apiCategory = "4d4b7105d754a06374d81259" // This is the "Food" category

    func fetchRestaurants(completion: @escaping ([Restaurant]?) -> Void) {
        var components = URLComponents(url: apiURL, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "limit", value: "10"),
            URLQueryItem(name: "categoryId", value: apiCategory),
            URLQueryItem(name: "client_id", value: apiKey),
            URLQueryItem(name: "client_secret", value: apiSecret)
        ]

        guard let url = components.url else {
            completion(nil)
            return
        }

        // Create the Foursquare API request
        let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("API Response JSON: \(jsonString)")
                }

                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(RestaurantResponse.self, from: data)
                    completion(response.results)
                } catch {
                    print("Error decoding restaurant data: \(error)")
                    completion(nil)
                }
            } else {
                print("Error fetching restaurant data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }.resume()

    }
}
