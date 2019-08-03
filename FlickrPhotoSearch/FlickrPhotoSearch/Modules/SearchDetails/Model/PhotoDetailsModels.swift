//
//  PhotoDetailsModels.swift
//  FlickrPhotoSearch
//
//  Created by Sauvik Dolui on 23/07/19.
//  Copyright © 2019 Sauvik Dolu. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct PhotoDetailsResult: Codable {
    var photo: PhotoDetails
    var stat: String?
    enum CodingKeys: String, CodingKey {
        case photo = "photo"
        case stat = "stat"
    }
}

// MARK: - Photo
struct PhotoDetails: Codable {
    var title, photoDescription: Description
    var tags: Tags
    func getTagsString(separator: String) -> String {
        guard tags.tag.count > 0 else { return "Not Available"}
        return tags.tag.map {$0.content }.joined(separator: separator)
    }
    func getDescription() -> String {
        guard photoDescription.content.count > 0 else { return "Not Available"}
        return photoDescription.content
    }
    enum CodingKeys: String, CodingKey {
        case title
        case photoDescription = "description"
        case tags
    }
}

// MARK: - Description
struct Description: Codable {
    var content: String
    
    enum CodingKeys: String, CodingKey {
        case content = "_content"
    }
}

// MARK: - Tags
struct Tags: Codable {
    var tag: [Tag]
}

// MARK: - Tag
struct Tag: Codable {
    var content: String
    enum CodingKeys: String, CodingKey {
        case content = "_content"
    }
}
