//
//  FlickrImageDetailsModelTest.swift
//  FlickrPhotoSearchTests
//
//  Created by Sauvik Dolui on 24/07/19.
//  Copyright © 2019 Sauvik Dolu. All rights reserved.
//

import XCTest
@testable import FlickrPhotoSearch

class FlickrImageDetailsModelTest: XCTestCase {

    var validResultJSON: String!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        validResultJSON = try! String(contentsOfFile: Bundle(for: FlickrImageSearchModelTest.self).path(forResource: "ImageDetails", ofType: "json")!)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_model_preparation() {
        
        var result = try! JSONDecoder().decode(PhotoDetailsResult.self, from: validResultJSON.data(using: .utf8)!)
        XCTAssertNotNil(result, "Result Must not be nil")
        XCTAssertEqual(result.stat, "ok", "Stat not same")
        XCTAssertNotNil(result.photo, "Photo must not be nil")
        XCTAssertNotNil(result.photo.title, "Title must not be nil")
        XCTAssertNotNil(result.photo.photoDescription, "Description must not be nil")
        XCTAssertNotNil(result.photo.tags, "Tags must not be nil")
        XCTAssertNotNil(result.photo.tags.tag, "Tag Array must not be nil")
        XCTAssertGreaterThan(result.photo.tags.tag.count, 0 , "tags array must contain more than one tag")
        XCTAssertEqual(result.photo.photoDescription.content,
                       "the ntypical nstreetnsceneninnevery ncitynnutter CHAOSnto the UNINITIATEDn ntotally normal nto  the  nlocal.nncatch the tout trying to ntake me to the spice marketnand Chadni Chowk  while nthe motorcyclist wants to bite his head offnfor being in his way.  nnTouts  are omnipresent ncannot be avoided.nnOLD DELHInin front of the JAMA MASJIDnthe largest MOSQUE in nthe largest Democracy in the worldnn",
                       "Desc does not match")
        
        
        // Empty Description Test
        result.photo.photoDescription.content = ""
        XCTAssertEqual(result.photo.getDescription(), "Not Available")
        
        // Tag tests
        let tags = result.photo.getTagsString(separator: ",")
        XCTAssertTrue(tags.count > 0, "Must value value in tags")
        
        // Zero Tag test
        result.photo.tags.tag = []
        XCTAssertEqual(result.photo.getTagsString(separator: ","), "Not Available")
    }
    

}
