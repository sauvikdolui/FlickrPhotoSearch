//
//  FlickrAPITest.swift
//  FlickrPhotoSearchTests
//
//  Created by Sauvik Dolui on 24/07/19.
//  Copyright © 2019 Sauvik Dolu. All rights reserved.
//

import XCTest
@testable import FlickrPhotoSearch

class FlickrAPITest: XCTestCase {

    let apiKey = AppConstants.flickrAPIKey
    let apiSecret = AppConstants.flickrAPISecret
    let baseURL = AppConstants.baseURL
    var apiStore: FlickrAPI!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        apiStore = FlickrAPI.store
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - Image Search API Test
    func test_valid_image_search_load() {
        
        let searchString = "Kolkata"
        let expectation = XCTestExpectation(description: "Valid Image Load Expectation")
        apiStore.searchImage(searchText: searchString) { (result, error) in
            if let result = result {
                XCTAssertTrue(result.stat == "ok", "Stat not same")
                XCTAssertTrue(result.photos.page == 1, "Page Count not same")
                XCTAssertTrue(result.photos.photo.count > 0, "Page Count not same")
                expectation.fulfill()
            } else if let _ = error {
                
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    // MARK: - Test Valid Image Details Load
    func test_valid_image_details_load() {
        
        let imageID = "48360268571"
        let expectation = XCTestExpectation(description: "Valid Image Load Expectation")
        apiStore.getDetails(id: imageID) { (result, error) in
            if let result = result {
                XCTAssertTrue(result.stat == "ok", "Stat not same")
                XCTAssertTrue(!result.photo.title.content.isEmpty, "Title must not be empty")
                XCTAssertTrue(!result.photo.getDescription().isEmpty, "Description must not be empty")
                XCTAssertTrue(!result.photo.getTagsString(separator: ",").isEmpty, "Tag list must not be empty")

                expectation.fulfill()
            } else if let _ = error {
                
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
}
