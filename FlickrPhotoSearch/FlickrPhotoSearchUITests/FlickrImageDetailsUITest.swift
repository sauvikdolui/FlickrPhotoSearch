//
//  FlickrImageDetailsUITest.swift
//  FlickrPhotoSearchUITests
//
//  Created by Sauvik Dolui on 24/07/19.
//  Copyright © 2019 Sauvik Dolu. All rights reserved.
//

import XCTest

class FlickrImageDetailsUITest: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app.launchArguments.append(UITestCommandLineArgument.details.rawValue)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_valid_data_load(){
        app.launch()
        XCTAssertTrue(app.isDetailsOnScreen, "Did not find screen, test failed")
        
        // Scroll
        let scroll = app.scrollViews.firstMatch
        XCTAssertTrue(scroll.waitForExistence(timeout: 0.0), "scroll must be there ")
        
        // Activity Indicator
        let spinner = scroll.activityIndicators.firstMatch
        //XCTAssertTrue(spinner.waitForExistence(timeout: 0.0), "spinner must be there ") // Okay with weak network connection
        
        // Image
        let imageView = scroll.children(matching: .image).firstMatch
        XCTAssertTrue(imageView.waitForExistence(timeout: 1.0), "imageView must be there ")

        // desc label
        let descLabel = scroll.descendants(matching: .staticText)["description"]
        XCTAssertTrue(descLabel.waitForExistence(timeout: 10.0), "descLabel must be there ")
        XCTAssertTrue(descLabel.label.count > 0, " Must have some descrition")

        //
        let tagsLabel = scroll.descendants(matching: .staticText)["tags"]
        XCTAssertTrue(tagsLabel.waitForExistence(timeout: 0.0), "tags must be there ")
        XCTAssertTrue(tagsLabel.label.count > 0, " Must have some descrition")

        
        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "Load Success"
        screenshot.lifetime = .keepAlways
        add(screenshot)
        
    }

}

extension XCUIApplication {
    var isDetailsOnScreen: Bool {
        return otherElements["SearchDetailsVCView"].exists
    }
}


