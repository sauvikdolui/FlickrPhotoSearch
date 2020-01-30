//
//  ImageStoreTest.swift
//  FlickrPhotoSearchTests
//
//  Created by Sauvik Dolui on 24/07/19.
//  Copyright © 2019 Sauvik Dolu. All rights reserved.
//

import XCTest
@testable import FlickrPhotoSearch

class ImageStoreTest: XCTestCase {

    var store:ImageStore = ImageStore.shared
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        store.purge()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func test_image_load() {
        
        let photo = Photo(id: "48256336996",
                          owner: "33264540@N05",
                          secret: "5a53a81b31",
                          server: "65535",
                          farm: 66,
                          title: "fish kebab seller at Zakaria street, Kolkata",
                          ispublic: 1,
                          isfriend: 0,
                          isfamily: 0,
                          urlT: "https://live.staticflickr.com/65535/48256336996_5a53a81b31_t.jpg",
                          heightT: 68,
                          widthT: 100,
                          photoLoadStatus: .unknown)
        
        var expectations = [XCTestExpectation]()
        for size in PhotoSize.allCases {
            let imageURL = photo.getImageURL(size: size)
            let expectation = XCTestExpectation(description: "Image Download Expectation for size \(size.rawValue)")
            expectations.append(expectation)
            store.loadImage(url: imageURL) { (data, error) in
                XCTAssertNotNil(data, "Image Data Must not be nil")
                XCTAssertNil(error, "Error must be nil")
                expectation.fulfill()
            }
        }
        wait(for: expectations, timeout: 60.0)
        
        // Cache Hit Test
        for size in PhotoSize.allCases {
            let imageURL = photo.getImageURL(size: size)
            XCTAssertNotNil(store.getImageData(key: imageURL), "Data Must not be nil after download")
        }
        
        //  Purge
        store.purge()
        for size in PhotoSize.allCases {
            let imageURL = photo.getImageURL(size: size)
            XCTAssertNil(store.getImageData(key: imageURL), "Data Must be nil after purge")
        }
        
        
    }
    

}
