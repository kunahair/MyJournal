//
//  testWalkthrough.swift
//  MyJournal
//
//  Created by Josh Gerlach on 22/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import XCTest

class testWalkthrough: XCTestCase {
    
    let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        //XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPlaces() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCUIApplication().launch()
 
        //Show scroll is available but not enough cells to actually scroll
        app.tables.containing(.other, identifier:"THIS WEEK").element.swipeUp()
        
        //Tap on Places Tab Bar
        let tabBarsQuery = app.tabBars
        let placesButton = tabBarsQuery.buttons["Places"]
        placesButton.tap()
        
        //Open a pin
        //app.otherElements["PopoverDismissRegion"].tap()
        
        app.otherElements["20-01-17, Upwey, Victoria, Australia"].tap()
        
        
        //Show more info
        app.buttons["More Info"].tap()
        
        //Click Back
        app.navigationBars["MyJournal.DetailView"].children(matching: .button).matching(identifier: "Back").element(boundBy: 0).tap()
        
        app.tabBars.buttons["Favourites"].tap()
        
        
        //Select first item
        app.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .image).element.tap()
        
        
        //Tap the favourites button and go back to show that the unfavourited entry is not there
        let myjournalDetailviewNavigationBar = app.navigationBars["MyJournal.DetailView"]
        myjournalDetailviewNavigationBar.buttons["heartfill"].tap()
        myjournalDetailviewNavigationBar.buttons["My Jounal"].tap()
        
        //Go Back to startup page
        app.tabBars.buttons["Home"].tap()
        
        //Compose new journal entry
        app.navigationBars["Main"].buttons["Add"].tap()
        
        
        //Select a new mood
        let elementsQuery = app.scrollViews.otherElements
        let happyPickerWheel = elementsQuery.pickerWheels["happy"]
        happyPickerWheel.swipeUp()
        
        //Add photo but cancel as test does not allow controll over gallary
        var scrollViewsQuery = app.scrollViews
        scrollViewsQuery.otherElements.buttons["selectPhoto"].tap()
        app.navigationBars["Photos"].buttons["Cancel"].tap()
        
        
        //Tap on note and type hello
        var element = app.scrollViews.otherElements.containing(.staticText, identifier:"My Journal").children(matching: .other).element
        let textView = element.children(matching: .other).element(boundBy: 2).children(matching: .textView).element
        textView.tap()
        textView.typeText("h")
        app.typeText("ello")
        
        
        element = app.scrollViews.otherElements.containing(.image, identifier:"border5").children(matching: .other).element
        element.children(matching: .other).element(boundBy: 2).children(matching: .textView).element.tap()
        element.tap()
        
        
        //Scroll down
        scrollViewsQuery = XCUIApplication().scrollViews
        element = scrollViewsQuery.otherElements.containing(.image, identifier:"border5").children(matching: .other).element
        element.swipeUp()
        //Toggle Map switch
        scrollViewsQuery.otherElements.switches["0"].tap()
        
        //Scroll up
        app.scrollViews.otherElements.containing(.image, identifier:"border5").children(matching: .other).element.swipeDown()
        
        //Add hi to Quote field
        let textField = app.scrollViews.otherElements.containing(.image, identifier:"border5").children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .textField).element
        textField.tap()
        textField.typeText("hi")
        
        //Save Journal Entry
        app.navigationBars["MyJournal.EditPage"].buttons["Save"].tap()
        
        //Select new entry
        app.tables.cells.element(boundBy: 0).tap()
        
        //Remove entry, goes back to main table view and shows that entry has been deleted
        app.navigationBars["MyJournal.DetailView"].buttons["Delete"].tap()

        
        
    }
    
}
