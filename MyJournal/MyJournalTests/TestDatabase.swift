//
//  TestDatabase.swift
//  MyJournal
//
//  Created by Josh Gerlach on 28/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import XCTest
@testable import MyJournal

/*
 To Rodney and Fardin:
 In our assignment files, each unit test file may contain multiple test cases, rather than one.
 Usually each func represents a single unit test case
 */

/**
 Test all Database functionality
 NOTE: All tests run in testDatabase method to ensure correct order of execution
 **/
class TestDatabase: XCTestCase {
    
    let journalID:String = "1"
    let journalID2:String = "2"
    
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    
    //Remove Database file from device and initialise a clean database
    func testDatabase(){
        
        var journalDBManager:JournalDBManager = JournalDBManager()
        XCTAssert(journalDBManager.removeDatabaseFile())
        XCTAssert(journalDBManager.initialiseDatabase())
        
        XCTAssert(journalDBManager.getAllJournalEntries()?.count == 3)
        
        getAllDefaultEntriesFromDatabase()
        insertJournalIntoDatabase()
        getNewInsertedJournalEntry()
        getAllEntriesInDatabase()
        deleteJournalEntryFromDatabase()
        toogleJournalEntryFavouriteToDatabase()
        removeTestDataFromDatabase()
    }
    
    //Test that the defaults are retrievable from the database
    func getAllDefaultEntriesFromDatabase()
    {
        var journalDBManager:JournalDBManager = JournalDBManager()
        let journalEntries:[String: Journal]? = journalDBManager.getAllJournalEntries()
        
        XCTAssert(journalEntries?.count == 3)
    }
    
    //Test inserting a new Journal Entry into database
    func insertJournalIntoDatabase() {
        //Create a default Journal Entry
        let journal:Journal = Journal(id: journalID)
        //Create new JournalDBManager instance
        var journalDBManager:JournalDBManager = JournalDBManager()
        //Check that Journal Entry is successfully inserted into Database
        XCTAssert(journalDBManager.addJournal(journal: journal))
    }
    
    //Test that the above Journal Entry is able to be retrieved from the Database
    func getNewInsertedJournalEntry(){
        //Create new JournalDBManager instance
        var journalDBManager:JournalDBManager = JournalDBManager()
        
        let journalEntry:Journal? = journalDBManager.getJournalEntryByKey(key: journalID)
        
        //Check that there is a result from the database
        XCTAssert(journalEntry != nil)
        //Check that the returned Journal Entry has the correct ID
        XCTAssert(journalEntry!.id == journalID)
    }
    
    //Test that a Dictionary of Journal Entries is returned from Database
    //Insert another Journal entry into database and test for 2 elements
    func getAllEntriesInDatabase()
    {
        var journalDBManager:JournalDBManager = JournalDBManager()
        
        //Insert another new Journal Entry
        let journal:Journal = Journal(id: journalID2)
        XCTAssert(journalDBManager.addJournal(journal: journal))
        
        //Get Journal Dictionary
        let journalEntries:[String: Journal]? = journalDBManager.getAllJournalEntries()
        
        //Check that the returned value is not nil
        XCTAssert(journalEntries != nil)
        //Check that there are 2 Journal Entreis
        XCTAssert(journalEntries!.count == 5)
        //Check that one entry contains the correct journalID
        XCTAssert(journalEntries![journalID]?.id == journalID)
        //Check that the other entry contains the correct journalID
        XCTAssert(journalEntries![journalID2]?.id == journalID2)
        
    }
    
    /**
     Test deletion of a Journal Entry from the database
     **/
    func deleteJournalEntryFromDatabase()
    {
        var journalDBManager:JournalDBManager = JournalDBManager()
        //Make sure that the entry is in the database
        XCTAssert(journalDBManager.getJournalEntryByKey(key: journalID)!.id == journalID)
        //Remove the first Test inserted Journal entry from the database
        XCTAssert(journalDBManager.deleteJournalEntryByKey(key: journalID))
        //Make sure that the removed Journal Entry is not present in the database
        XCTAssert(journalDBManager.getJournalEntryByKey(key: journalID) == nil)
    }
    
    func toogleJournalEntryFavouriteToDatabase()
    {
        var journalDBManager:JournalDBManager = JournalDBManager()
        //Get Journal Entry from Database
        let journalEntry:Journal? = journalDBManager.getJournalEntryByKey(key: journalID2)
        //Test that the Journal Entry is not nil
        XCTAssert(journalEntry != nil)
        //Change the Journal Entry Favourite in the Database and test the result
        XCTAssert(journalDBManager.toggleJournalFavouriteByKey(key: journalID2))
        //Make sure that the Database Journal Entry favourite value does not equal the original value
        XCTAssert(journalDBManager.getJournalEntryByKey(key: journalID2)!.favorite != journalEntry!.favorite)
    }
    
    /**
     Remove the journal entries that the tests inserted, test along the way for good practice
     **/
    func removeTestDataFromDatabase()
    {
        var journalDBManager:JournalDBManager = JournalDBManager()
        //Remove any entries inserted by test
        XCTAssert(journalDBManager.deleteJournalEntryByKey(key: journalID2))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
