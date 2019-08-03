//
//  FlickrImageSearchUITest.swift
//  FlickrPhotoSearchUITests
//
//  Created by Sauvik Dolui on 24/07/19.
//  Copyright © 2019 Sauvik Dolu. All rights reserved.
//

import XCTest

class FlickrImageSearchUITest: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app.launchArguments.append(UITestCommandLineArgument.search.rawValue)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_valid_search_flow(){
        app.launch()
        XCTAssertTrue(app.isSearchOnScreen, "Did not find screen, test failed")
        
        let statusLabel = app.staticTexts.firstMatch
        XCTAssertTrue(statusLabel.waitForExistence(timeout: 2.0), "statusLabel must be there ")
        XCTAssertTrue(statusLabel.label == "Start typing to get result")

        let searchBar = app.searchFields.firstMatch
        XCTAssertTrue(searchBar.exists, "Did not find serach bar on screen")
        searchBar.tap()
        searchBar.typeText("kolkata")

        
        // Search Result on Table View
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 10.0), "Table View Must appear")
        //XCTAssertFalse(statusLabel.waitForExistence(timeout: 10.0), "statusLabel must not be visible ")
        
        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "Search Success"
        screenshot.lifetime = .keepAlways
        add(screenshot)
        
    }
    func test_zero_result_search_flow(){
        app.launch()
        XCTAssertTrue(app.isSearchOnScreen, "Did not find screen, test failed")
        
        let statusLabel = app.staticTexts.firstMatch
        XCTAssertTrue(statusLabel.waitForExistence(timeout: 2.0), "statusLabel must be there ")
        let searchBar = app.searchFields.firstMatch
        XCTAssertTrue(searchBar.exists, "Did not find serach bar on screen")
        searchBar.tap()
        searchBar.typeText("rfreijiorefij89345tertnmrmo4nmrm")
        
        
        // Search Result on Table View
        XCTAssertTrue(statusLabel.waitForExistence(timeout: 20.0), "statusLabel must be visible ")
        XCTAssertTrue(statusLabel.label == "NO RESULT FOUND")

        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "Success: Zero Result"
        screenshot.lifetime = .keepAlways
        add(screenshot)
        
    }
    
    func test_navigation_to_details_from_search_flow(){
        app.launch()
        XCTAssertTrue(app.isSearchOnScreen, "Did not find screen, test failed")
        
        let statusLabel = app.staticTexts.firstMatch
        XCTAssertTrue(statusLabel.waitForExistence(timeout: 2.0), "statusLabel must be there ")
        
        
        let searchBar = app.searchFields.firstMatch
        XCTAssertTrue(searchBar.exists, "Did not find serach bar on screen")
        searchBar.tap()
        searchBar.typeText("kolkata")
        
        
        // Search Result on Table View
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 10.0), "Table View Must appear")
        
        
        // Tap on Cell
        let firstCell = tableView.cells.element(boundBy: 0)
        firstCell.tap()
        
        XCTAssertFalse(app.isSearchOnScreen, "New Screen must be open")
        
        XCTAssertTrue(app.isDetailsOnScreen, "Details Screen should be on screen")
        
        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "Success: Zero Result"
        screenshot.lifetime = .keepAlways
        add(screenshot)
        
    }

}

extension XCUIApplication {
    var isSearchOnScreen: Bool {
        return otherElements["SearchImageVCView"].exists
    }
}
