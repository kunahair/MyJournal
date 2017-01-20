//
//  testMainTableView.swift
//  MyJournal
//
//  Created by Josh Gerlach on 20/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import XCTest

class testMainTableView: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSlideOnCell() {
        XCUIApplication().launch()

        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        //Get reference to main table view
        let tablesQuery = app.tables.cells
        //Test that the delete button is not present
        XCTAssert(!tablesQuery.element(boundBy: 0).buttons["Delete"].exists)
        //Swipe left on first cell to show delete button
        tablesQuery.element(boundBy: 0).swipeLeft()
        //Test that the delete button is present
        XCTAssert( tablesQuery.element(boundBy: 0).buttons["Delete"].exists)
        //Swiple left on cell to remove Delete butotn
        tablesQuery.element(boundBy: 0).swipeRight()
    }
    
    func testTapCellToDetailView() {
        
        //Get reference to main table view
        let tablesQuery = app.tables.cells
        
        //Tap first element on table, should bring up Details view
        tablesQuery.element(boundBy: 0).tap()
        
        //Set up a reference to the "Main" button in the navigation bar that is only present
        //When user segues from MainTableView
        let label = app.navigationBars["MyJournal.DetailView"].buttons["Main"]
        //NSPredicate setting terms for expectations
        let exists = NSPredicate(format: "exists == 1")
        
        //Wait for MyJournal->DetailsView to load and test that it has indeed loaded using the Main Button as a reference
        //Wait for 5 seconds
        expectation(for: exists, evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
