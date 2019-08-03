//
//  ImageDetailsEndPoint.swift
//  FlickrPhotoSearch
//
//  Created by Sauvik Dolui on 24/07/19.
//  Copyright © 2019 Sauvik Dolu. All rights reserved.
//

import Foundation

struct ImageDetailsEndPoint: FlickrResourceEndPoint {
    var method: String
    var format: ResponseFormat
    var noJSONCallBack: Int
    
    var imageID: String
    
    private init(format: ResponseFormat, noJSONCallBack: Int, imageID: String) {
        self.method = "flickr.photos.getInfo"
        self.format = format
        self.noJSONCallBack = noJSONCallBack
        self.imageID = imageID
 
    }
    init(imageID: String) {
        self.init(format: .JSON, noJSONCallBack: 1, imageID: imageID)
    }
    
    func getJSONLoadURL(baseURL: String, secret: String, apiKey: String) -> URL? {
        return URL(string: baseURL + getQueryDic(baseURL: baseURL, secret: secret, apiKey: apiKey).queryString)
    }
    // Unit Test Coverage
    func getQueryDic(baseURL: String, secret: String, apiKey: String) -> [String: String] {
        let queryParams: [String: String] = [
            "method" : self.method,
            "api_key" : apiKey,
            "secret": secret,
            "format": self.format.rawValue,
            "nojsoncallback": "\(self.noJSONCallBack)",
            "photo_id": self.imageID,
        ]
        return queryParams
    }
}
