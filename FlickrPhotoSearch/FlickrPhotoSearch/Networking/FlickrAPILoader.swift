//
//  FlickrAPILoader.swift
//  FlickrPhotoSearch
//
//  Created by Sauvik Dolui on 24/07/19.
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

// MARK: - FlickrAPILoader
protocol FlickrAPILoader {
    
    // Properties
    var apiKey: String { get }
    var secret: String { get }
    
    // Initialization
    init(apikey: String, secret: String, baseURL: String)
    
    // API Load
    func searchImage(searchText: String, handler: @escaping SearchResult)
    func getDetails(id: String, handler: @escaping PhotoDetailsFetchResult)
}

// MARK: - FlickrResourceEndPoint
protocol FlickrResourceEndPoint {
    var method: String { get }
    var format: ResponseFormat { get }
    var noJSONCallBack: Int { get }
    func getJSONLoadURL(baseURL: String, secret: String, apiKey: String) -> URL?
}

extension FlickrResourceEndPoint {
    var baseQueryParams: [String : String] {
        return [
            "method" : self.method,
            "format": self.format.rawValue,
            "nojsoncallback": "\(self.noJSONCallBack)",
        ]
    }
}

enum ResponseFormat: String {
    case JSON = "json"
    case XML = "xml"
    // TODO: Add more formats, check API Explorer
}




