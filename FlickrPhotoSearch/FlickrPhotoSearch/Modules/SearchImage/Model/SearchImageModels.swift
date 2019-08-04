//
//  SearchImageModels.swift
//  FlickrPhotoSearch
//
//  Created by Sauvik Dolui on 23/07/19.
//  Copyright © 2019 Sauvik Dolu. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct FlickrSearchResult: Codable {
    let photos: Photos
    let stat: String
}

// MARK: - Photos
struct Photos: Codable {
    let page, pages, perpage: Int
    let total: String
    let photo: [Photo]
}

enum PhotoLoadStatus: Int {
    case unknown
    case loaded
    case loading
    case loadError
}

enum PhotoSize: Int, CaseIterable {
    case thumbNail
    case medium
    case original
    case small
    
    var pathSuffix: String {
        switch self {
        case .small: return "_s"
        case .thumbNail: return "_t"
        case .medium: return "_m"
        case .original: return "" // 410, File Not Found Error Code
        }
    }
    var searchExtraValue: String {
        return "url" + pathSuffix
    }
}
// MARK: - Photo
struct Photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
    let urlT: String
    let heightT, widthT: String
    
    var photoLoadStatus: PhotoLoadStatus = .unknown
    
    enum CodingKeys: String, CodingKey {
        case id, owner, secret, server, farm, title, ispublic, isfriend, isfamily
        case urlT = "url_t"
        case heightT = "height_t"
        case widthT = "width_t"
    }
    
    func getImageURL(size: PhotoSize) -> String {
        // https://www.flickr.com/services/api/misc.urls.html
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)\(size.pathSuffix).jpg"
    }
    
    
}
