//
//  testDetailView.swift
//  MyJournal
//
//  Created by Yuanqing Jiang on 20/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import XCTest

class testDetailView: XCTestCase {

    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDetail() {
        XCUIApplication().launch()
        
        let tablesQuery = XCUIApplication().tables
        tablesQuery.children(matching: .cell).element(boundBy: 0).staticTexts["22-01-17"].tap()
        tablesQuery.cells.staticTexts["22-01-17"].tap()
        // test journal is there
        //XCTAssert(tablesQuery.cells.staticTexts["Journal"].exists)
        
        let bar = XCUIApplication().navigationBars["MyJournal.DetailView"]
        
        XCUIApplication().tables.staticTexts["I was at Melbourne, Victoria, Australia"].tap()
        XCUIApplication().tables.staticTexts["Journal"].swipeUp()
        
        tablesQuery.staticTexts["Journal"].swipeUp()
        tablesQuery.staticTexts["Shot of the Day"].swipeUp()

        
        tablesQuery.staticTexts["Music of the Day"].tap()
        // test music label is there
        XCTAssert(tablesQuery.staticTexts["Music of the Day"].exists)
        
        
        // test if buttons are there
        XCTAssert(bar.buttons["heartfill"].exists)
        XCTAssert(bar.buttons["Delete"].exists)
        
        bar.buttons["heartfill"].tap()
        // test if state changed
        XCTAssert(bar.buttons["heart"].exists)
        
        bar.buttons["heart"].tap()
        bar.buttons["Delete"].tap()
        
        
    }
    
}
