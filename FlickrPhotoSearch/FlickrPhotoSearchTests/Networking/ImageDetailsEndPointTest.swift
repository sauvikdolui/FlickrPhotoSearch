//
//  ImageDetailsEndPointTest.swift
//  FlickrPhotoSearchTests
//
//  Created by Sauvik Dolui on 24/07/19.
//  Copyright © 2019 Sauvik Dolu. All rights reserved.
//

import XCTest
@testable import FlickrPhotoSearch

class ImageDetailsEndPointTest: XCTestCase {

    let apiKey = AppConstants.flickrAPIKey
    let apiSecret = AppConstants.flickrAPISecret
    let baseURL = AppConstants.baseURL
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func test_valid_url() {
        let imageID = "20623341171"
        let endPoint = ImageDetailsEndPoint(imageID: imageID)
        
        // URL testing
        let detailsURL = endPoint.getJSONLoadURL(baseURL: baseURL, secret: apiSecret, apiKey: apiKey)
        XCTAssertNotNil(detailsURL, "URL must not be nil")
        XCTAssertTrue(detailsURL!.absoluteString.isValidUrl(), "URL String is not valid")

    }
    
    func test_query() {
        let imageID = "20623341171"
        let endPoint = ImageDetailsEndPoint(imageID: imageID)
        
        // Query Testing
        let query = endPoint.getQueryDic(baseURL: baseURL, secret: apiSecret, apiKey: apiKey)

        XCTAssertEqual(query["method"], endPoint.method, "Method not same")
        XCTAssertEqual(query["format"], endPoint.format.rawValue, "format not same")
        XCTAssertEqual(query["api_key"], apiKey, "format not same")
        XCTAssertEqual(query["secret"], apiSecret, "secret not same")
        XCTAssertEqual(query["nojsoncallback"], "1", "nojsoncallback not same")
        XCTAssertEqual(query["photo_id"], imageID, "ID not same")
 
    }

}
