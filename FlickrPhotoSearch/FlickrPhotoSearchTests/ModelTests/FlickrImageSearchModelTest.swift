//
//  FlickrImageSearchModelTest.swift
//  FlickrPhotoSearchTests
//
//  Created by Sauvik Dolui on 24/07/19.
//  Copyright © 2019 Sauvik Dolu. All rights reserved.
//

import XCTest
@testable import FlickrPhotoSearch

class FlickrImageSearchModelTest: XCTestCase {

    var validResultJSON: String!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        validResultJSON = try! String(contentsOfFile: Bundle(for: FlickrImageSearchModelTest.self).path(forResource: "ImageSearchResult", ofType: "json")!)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_model_preparation() {
        
        let result = try! JSONDecoder().decode(FlickrSearchResult.self, from: validResultJSON.data(using: .utf8)!)
        XCTAssertNotNil(result, "Result Must not be nil")
        
        XCTAssertEqual(result.stat, "ok", "stat Must not be nil")
        XCTAssertNotNil(result.photos, "Photos Must not be nil")
        XCTAssertEqual(result.photos.page, 1, "page index not same")
        XCTAssertEqual(result.photos.pages, 3, "total page count not same")
        XCTAssertEqual(result.photos.perpage, 100, "perpage count not same")
        XCTAssertEqual(result.photos.total, "285", "total count not same")
        XCTAssertGreaterThan(result.photos.photo.count, 0, "first page total count mus not be 0")
        
        for photo in result.photos.photo {
            XCTAssertNotNil(photo.id, "id must not be nil")
            XCTAssertNotNil(photo.owner, "owner must not be nil")
            XCTAssertNotNil(photo.secret, "secret must not be nil")
            XCTAssertNotNil(photo.server, "server must not be nil")
            XCTAssertNotNil(photo.farm, "farm must not be nil")
            XCTAssertNotNil(photo.title, "title must not be nil")
            XCTAssertNotNil(photo.ispublic, "ispublic must not be nil")
            XCTAssertNotNil(photo.urlT, "urlT must not be nil")
            XCTAssertNotNil(photo.heightT, "heightT must not be nil")
            XCTAssertNotNil(photo.widthT, "widthT must not be nil")
            
            // Image URL Preparation test
            for size in PhotoSize.allCases {
                let urlstring = "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)\(size.pathSuffix).jpg"
                let imageURLString = photo.getImageURL(size: size)
                XCTAssertEqual(urlstring, imageURLString, "Error in image url preparation")
            }
        }
    }

}
