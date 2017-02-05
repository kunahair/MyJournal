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
    
    
    /**
     Updated Walkthrough to show some of the new features.
     Gives you an idea, does not show Edit or deletion
    **/
    func testUpdatedWalkthrough() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCUIApplication().launch()
        
        let app = XCUIApplication()
        app.tables.containing(.other, identifier:"THIS WEEK").element.swipeUp()
        
        
        /**
         UITest Places Tab
        **/
        app.tabBars.buttons["Places"].tap()
        
        var element = app.otherElements["03-02-17, Melbourne, Victoria, Australia"]
        element.tap()
        
        
        
        let moreInfoButton = app.buttons["More Info"]
        moreInfoButton.tap()
        
        let tablesQuery = app.tables
       
        let journalStaticText = tablesQuery.staticTexts["Journal"]
        journalStaticText.swipeUp()
        
        let iWasAtStaticText = tablesQuery.staticTexts["I Was at"]
        iWasAtStaticText.swipeUp()
        iWasAtStaticText.swipeUp()
        
        XCUIApplication().navigationBars["MyJournal.DetailView"].children(matching: .button).matching(identifier: "Back").element(boundBy: 0).tap()
        
        
        
        /**
         UITest Favourites Tab
        **/
        
        app.tabBars.buttons["Favourites"].tap()
        app.collectionViews.children(matching: .cell).element(boundBy: 0).images["defaultphoto"].tap()
        
        let myjournalDetailviewNavigationBar = app.navigationBars["MyJournal.DetailView"]
        myjournalDetailviewNavigationBar.buttons["Compose"].tap()
        app.buttons["Export"].tap()
        app.images["1"].swipeUp()
        app.navigationBars["Preview"].buttons["Back"].tap()
        myjournalDetailviewNavigationBar.buttons["heartfill"].tap()
        myjournalDetailviewNavigationBar.buttons["My Jounal"].tap()
        
        
        /**
         Test Add New Entry
        **/
        
        XCUIApplication().tabBars.buttons["Home"].tap()
        
        
        app.navigationBars["Main"].buttons["Add"].tap()
        
        if app.alerts["Allow “MyJournal” to access your location while you use the app?"].exists
        {
            app.alerts["Allow “MyJournal” to access your location while you use the app?"].buttons["Allow"].tap()
        }
        
        
        var scrollViewsQuery = app.scrollViews
        let happyPickerWheel = scrollViewsQuery.otherElements.pickerWheels["happy"]
        happyPickerWheel.swipeUp()
        
        element = scrollViewsQuery.otherElements.containing(.image, identifier:"border5").children(matching: .other).element
        let textView = element.children(matching: .other).element(boundBy: 3).children(matching: .textView).element
        textView.tap()
        textView.typeText("H")
        app.typeText("ello")
        
        
        scrollViewsQuery = app.scrollViews
        element = scrollViewsQuery.otherElements.containing(.image, identifier:"border5").children(matching: .other).element
        let textField = element.children(matching: .other).element(boundBy: 2).children(matching: .textField).element
        textField.tap()
        textField.typeText("Hi")
        element.swipeUp()
        
        let elementsQuery = scrollViewsQuery.otherElements
        let selectphotoButton = elementsQuery.buttons["selectPhoto"]
        selectphotoButton.tap()
        
        if app.alerts["“MyJournal” Would Like to Access Your Photos"].exists
        {
            app.alerts["“MyJournal” Would Like to Access Your Photos"].buttons["OK"].tap()
        }
        
        
        app.navigationBars["Photos"].buttons["Cancel"].tap()
        selectphotoButton.swipeUp()
        element.children(matching: .other).element(boundBy: 6).buttons["Button"].tap()
        
        
        XCUIApplication().navigationBars["YouTube"].buttons["Save Video"].tap()

        XCUIApplication().scrollViews.otherElements.staticTexts["Video"].swipeDown()
        
        app.navigationBars["MyJournal.EditPage"].buttons["Save"].tap()
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Favourites"].tap()
        tabBarsQuery.buttons["Home"].tap()
        
        
    }
    
    /**
     NOTE: This Test does not work anymore
     Kept as a show of prior work
    **/
    func testOldWalkthrough() {
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
