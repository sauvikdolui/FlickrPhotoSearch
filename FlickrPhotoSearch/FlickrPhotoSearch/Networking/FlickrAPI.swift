//
//  FlickrAPI.swift
//  FlickrPhotoSearch
//
//  Created by Sauvik Dolui on 23/07/19.
//  Copyright © 2019 Sauvik Dolu. All rights reserved.
//

import Foundation

typealias SearchResult = (FlickrSearchResult?, Error?) -> Void
typealias PhotoDetailsFetchResult = (PhotoDetailsResult?, Error?) -> Void

enum FlickrAPIError : Error {
    case invalidStatusCode(code: Int)
    case invalidURL
    case parsingError
    case unknownError
}


class FlickrAPI: FlickrAPILoader {
    
    
    // Singleton
    static let store = FlickrAPI(apikey: AppConstants.flickrAPIKey,
                                 secret: AppConstants.flickrAPISecret,
                                 baseURL: AppConstants.baseURL)
    
    let apiKey: String
    let secret: String
    let baseURL: String
    
    // MARK: - Initialization
    // TODO: Private?
    required init(apikey: String, secret: String, baseURL: String) {
        self.apiKey = apikey
        self.secret = secret
        self.baseURL = baseURL
    }

    
    
    func searchImage(searchText: String, handler: @escaping SearchResult) {
        let endPoint = ImageSearchEndPoint(searchText: searchText, imageSize: .thumbNail)
        load(endPoint: endPoint, handler: handler)
    }
    
    func getDetails(id: String, handler: @escaping PhotoDetailsFetchResult) {
        let endPoint = ImageDetailsEndPoint(imageID: id)
        load(endPoint: endPoint, handler: handler)
    }
    
    // MARK: - API Loads
    func load<FlickrAPIResult>(endPoint: FlickrResourceEndPoint,
                                       handler: @escaping (FlickrAPIResult?, Error?) -> Void) where FlickrAPIResult : Decodable {
        
        // TODO: Cancel existing task if there if an ongoing one
        guard let url = endPoint.getJSONLoadURL(baseURL: self.baseURL, secret: self.secret, apiKey: self.apiKey) else {
            handler(nil, FlickrAPIError.invalidURL)
            return
        }
        let dataTask = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
            
            DispatchQueue.main.async {
                if let error = error {
                    handler(nil, error)
                } else if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                    handler(nil, FlickrAPIError.invalidStatusCode(code: response.statusCode))
                } else if let data = data {
                    // Try to parse Data
                    guard let result = try? JSONDecoder().decode(FlickrAPIResult.self, from: data) else {
                        handler(nil, FlickrAPIError.parsingError)
                        return
                    }
                    handler(result, nil)
                } else {
                    // Unknown State
                    handler(nil, FlickrAPIError.unknownError)
                }
            }
        }
        dataTask.resume()
    }
    // TODO: Add support for loading arrays
}
