//
//  FlickrAPILoader.swift
//  FlickrPhotoSearch
//
//  Created by Sauvik Dolui on 24/07/19.
//  Copyright © 2019 Sauvik Dolu. All rights reserved.
//

import Foundation

protocol FlickrAPILoader {
    
    // MARK: - Private Properties

    var apiKey: String { get }
    var secret: String { get }
    
    // MARK: - Initialization
    init(apikey: String, secret: String, baseURL: String)
    
    // MARK: API Load
    func searchImage(searchText: String, handler: @escaping SearchResult)
    func getDetails(id: String, handler: @escaping PhotoDetailsFetchResult)
}

protocol FlickrResourceEndPoint {
    var method: String { get set }
    var format: ResponseFormat { get set }
    var noJSONCallBack: Int { get set}
    func getJSONLoadURL(baseURL: String, secret: String, apiKey: String) -> URL?
}

enum ResponseFormat: String {
    case JSON = "json"
    case XML = "xml"
    // TODO: Add more formats, check API Explorer
}




