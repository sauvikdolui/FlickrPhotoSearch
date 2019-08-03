//
//  ImageSearchEndPoint.swift
//  FlickrPhotoSearch
//
//  Created by Sauvik Dolui on 24/07/19.
//  Copyright © 2019 Sauvik Dolu. All rights reserved.
//

import Foundation

struct ImageSearchEndPoint: FlickrResourceEndPoint {
    var method: String = "flickr.photos.search"
    var format: ResponseFormat
    var noJSONCallBack: Int
    
    var searchText: String
    var imageSize: PhotoSize
    
    private init(format: ResponseFormat, noJSONCallBack: Int, searchText: String, imageSize: PhotoSize) {
        self.format = format
        self.noJSONCallBack = noJSONCallBack
        self.searchText = searchText
        self.imageSize = imageSize
    }
    init(searchText: String, imageSize: PhotoSize) {
        self.init(format: .JSON, noJSONCallBack: 1, searchText: searchText, imageSize: imageSize)
    }
    
    func getJSONLoadURL(baseURL: String, secret: String, apiKey: String) -> URL? {
        return URL(string: baseURL + getQuery(baseURL: baseURL, secret: secret, apiKey: apiKey, text: self.searchText).queryString)
    }
    
    func getQuery(baseURL: String, secret: String, apiKey: String, text: String) -> [String: String] {
        let urlEncodedSearchText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return self.baseQueryParams + [
            "api_key" : apiKey,
            "secret": secret,
            "text": urlEncodedSearchText,
            "extras" : imageSize.searchExtraValue
        ]
    }
}
