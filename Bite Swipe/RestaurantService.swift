//
//  RestaurantService.swift
//  Bite Swipe
//
//  Created by Ian Rowland on 11/2/23.
//

import Foundation

class RestaurantService {
    private let apiURL = "https://api.foursquare.com/v3/places/search?categories=13000"
    private let apiKey = "fsq3kl7NeyCzFZSmIzk4VZaT3iww2HUeylc4XB3NA/crDPA="
    private let photoApiURL = "https://api.foursquare.com/v3/places/" // Add the photo API URL

    func fetchRestaurants(zipCode: String, completion: @escaping ([Restaurant]?) -> Void) {
        let dynamicApiURL = apiURL + "&near=" + zipCode + "&limit=50"
        
        guard let url = URL(string: dynamicApiURL) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Response.self, from: data)
                    let restaurants = response.results.map { result in
                        return Restaurant(
                            fsq_id: result.fsq_id,
                            name: result.name,
                            cuisine: result.categories.first?.short_name ?? "",
                            location: result.location.formatted_address,
//                            postcode: result.location.postcode
                            latitude: result.geocodes.main.latitude,
                            longitude: result.geocodes.main.longitude
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

    func fetchPhotos(venueID: String, completion: @escaping (Swift.Result<[Photo]?, Error>) -> Void) {
        let headers = [
            "accept": "application/json",
            "Authorization": apiKey
        ]

        guard let url = URL(string: "\(photoApiURL)\(venueID)/photos") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared

        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let photos = try decoder.decode([Photo].self, from: data)
                    completion(.success(photos))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
            }
        }

        dataTask.resume()
    }
}


private struct Response: Decodable {
    let results: [Result]
}

private struct Result: Decodable {
    let fsq_id: String
    let name: String
    let categories: [Category]
    let location: Location
    let geocodes: Geocodes

    struct Category: Decodable {
        let name: String
        let short_name: String
    }

    struct Location: Decodable {
        let formatted_address: String
    }

    struct Geocodes: Decodable {
        let main: MainGeocode

        struct MainGeocode: Decodable {
            let latitude: Double
            let longitude: Double
        }
    }
}

struct Photo: Decodable {
    let id: String
    let createdAt: String
    let prefix: String
    let suffix: String
    let width: Int
    let height: Int
    let classifications: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case prefix
        case suffix
        case width
        case height
        case classifications
    }
}

