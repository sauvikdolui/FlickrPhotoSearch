//
//  ImageStore.swift
//  FlickrPhotoSearch
//
//  Created by Sauvik Dolui on 24/07/19.
//  Copyright © 2019 Sauvik Dolu. All rights reserved.
//

import Foundation

typealias ImageLoadResult = (Data?, Error?) -> Void

class ImageStore {
    
    // Singleton
    static let shared = ImageStore()
    
    // MARK: - Initialization
    private init() {
        
    }

    // Look up
    private var _imageCache = [String: Data]()
    
    func loadImage(url: String, handler: @escaping ImageLoadResult) {
        
        if let data = _imageCache[url]  {
            // Cache hit
            handler(data, nil)
            return
        }
        guard let imageURL = URL(string: url) else {
            handler(nil, FlickrAPIError.invalidURL)
            return
        }
        let dataTask = URLSession(configuration: .default).dataTask(with: imageURL) { [weak self] (data, response, error) in
            guard let welf = self else { return }
            DispatchQueue.main.async {
                if let error = error {
                    handler(nil, error)
                } else if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                    handler(nil, FlickrAPIError.invalidStatusCode(code: response.statusCode))
                } else if let data = data {
                    // Populate Cache
                    welf._imageCache[url] = data
                    
                    // Send a copy of data
                    handler(data, nil)

                } else {
                    // Unknown State
                    handler(nil, FlickrAPIError.unknownError)
                }
            }
        }
        dataTask.resume()
    }
    func purge() {
        _imageCache = [:]
    }
    func getImageData(key: String) -> Data? {
        return _imageCache[key]
    }
}
