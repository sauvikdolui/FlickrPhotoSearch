//
//  FlickrImageSearchEndPointTest.swift
//  FlickrPhotoSearchTests
//
//  Created by Sauvik Dolui on 24/07/19.
//  Copyright © 2019 Sauvik Dolu. All rights reserved.
//

import XCTest
@testable import FlickrPhotoSearch


class FlickrImageSearchEndPointTest: XCTestCase {

    let apiKey = AppConstants.flickrAPIKey
    let apiSecret = AppConstants.flickrAPISecret
    let baseURL = AppConstants.baseURL
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    
    // MARK: - End Point Testing
    func test_search_end_point_valid_url(){
        let searchString = "kolkata"
        let imageSize = PhotoSize.small
        let searchEndPoint = ImageSearchEndPoint(searchText: searchString, imageSize: imageSize)

        
        // URL testing
        let searchURL = searchEndPoint.getJSONLoadURL(baseURL: baseURL,
                                                      secret: apiSecret,
                                                      apiKey: apiKey)
        XCTAssertNotNil(searchURL, "URL must not be nil")
        XCTAssertTrue(searchURL!.absoluteString.isValidUrl(), "URL String is not valid")
    }
    
    func test_query_preparation() {
        let searchString = "kolkata"
        let imageSize = PhotoSize.small
        let searchEndPoint = ImageSearchEndPoint(searchText: searchString, imageSize: imageSize)
        
        
        // TODO: Add query assertions
        let query = searchEndPoint.getQuery(baseURL: baseURL, secret: apiSecret, apiKey: apiKey, text: searchString)
        XCTAssertEqual(query["method"], searchEndPoint.method, "Method not same")
        XCTAssertEqual(query["format"], searchEndPoint.format.rawValue, "format not same")
        XCTAssertEqual(query["text"], searchEndPoint.searchText, "Search not same")
        XCTAssertEqual(query["api_key"], apiKey, "format not same")
        XCTAssertEqual(query["secret"], apiSecret, "secret not same")
        XCTAssertEqual(query["nojsoncallback"], "1", "nojsoncallback not same")
        XCTAssertEqual(query["extras"], imageSize.searchExtraValue, "image size not same")
    }

}
