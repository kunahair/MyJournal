//
//  MyJournalUITests.swift
//  MyJournalUITests
//
//  Created by WEIZHUO TIAN on 12/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import XCTest

class MyJournalUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        
        //Get reference to main table view
        let tablesQuery = app.tables.cells
        //Test that the delete button is not present
        XCTAssert(!tablesQuery.element(boundBy: 0).buttons["Delete"].exists)
        //Swipe left on first cell to show delete button
        tablesQuery.element(boundBy: 0).swipeLeft()
        //Test that the delete button is present
        XCTAssert( tablesQuery.element(boundBy: 0).buttons["Delete"].exists)
        //Tap first element on table
        tablesQuery.element(boundBy: 0).tap()
        
        //let label = app.staticTexts["If everything could feel this real forever"]
        //let label = app.navigationBars["MyJournal.DetailView"].buttons["Main"]
        //let exists = NSPredicate(format: "exists == 1")
        
        //expectation(for: exists, evaluatedWith: label, handler: nil)
        //waitForExpectations(timeout: 10, handler: nil)

        
        //XCTAssert(app.navigationBars["MyJournal.DetailView"].buttons["Main"].exists)
        
        
        //waitForExpectations(timeout: 3, handler: nil)
        
        //XCTAssertEqual(app.navigationBars.element.identifier, "DetailView")
        
        
        
        
        
        
        
        //let cellQuery = app.tables.cells.containing(.staticText, identifier:"recell")
        
        //XCUIApplication().tables.staticTexts["Title"].tap()
        }
    
}
