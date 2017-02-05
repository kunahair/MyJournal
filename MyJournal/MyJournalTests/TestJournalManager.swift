//
//  TestJournalManager.swift
//  MyJournal
//
//  Created by Josh Gerlach on 5/2/17.
//  Copyright © 2017 Xing. All rights reserved.
//

import XCTest
@testable import MyJournal

class TestJournalManager: XCTestCase {
    
    var journalManager:JournalManger = JournalManger()
    var journalDBManager:JournalDBManager = JournalDBManager()
    let journalID1 = "1"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAllJournalManagerTests() {
        testInsertIntoJournalManager()
        testInsertValuesIntoJournalManager()
        testUpdateJournalFromJournalManager()
        testDeleteFromJournalManager()
        testUnableToInsertEmptyNote()
    }
    
    /**
     Test that a test Journal Entry can be added
     **/
    func testInsertIntoJournalManager() {
        //If the test Journal Entry is in the Journal Manager, delete it
        if journalManager.getJournalEntryByKey(key: journalID1) != nil {
            XCTAssertTrue(journalManager.deleteJournalEntryByKey(key: journalID1))
        }
        
        //Get current count of Journals in JournalManager
        let journalEntriesCount:Int = journalManager.getAllJournalEntries()!.count
        //Create a Journal Entry for testing
        let journal:Journal = Journal(id: journalID1)
        
        //Test that we are able to insert the Journal into the Manager
        XCTAssertTrue(journalManager.addJournal(journal: journal))
        //Test that the count of Journal Entries has increased by one
        XCTAssertTrue(journalManager.getAllJournalEntries()!.count == (journalEntriesCount + 1))
        //Test that the journal is retreivable from the Manager
        XCTAssertNotNil(journalManager.getJournalEntryByKey(key: journalID1), "No Journal Found with ID " + journalID1)
    }
    
    /**
     Test that the Journal Manager can insert a Journal using parameter function overload
     NOTE: It does also test delete as it is hard to keep track of the index of a Journal Entry that has the ID dynamically created.
     **/
    func testInsertValuesIntoJournalManager() {
        
        //Insert a new Journal Entry into the Manager using variables instead of a Journal Entry
        XCTAssertTrue(journalManager.addJournal(note: "Hello", music: nil, quote: "What a day!", photo: "defaultphoto", weather: "sunny", mood: "happy", date: "06/02/2017", location: "MCG Melbourne", favorite: false, coordinates: [-37.0, 144.0], recordName: nil, videoURL: nil))
        //Get the index of the newly inserted Journal Entry
        let testJournalIndex:Int = journalManager.getAllJournalEntries()!.count - 1
        
        //Test that the test Journal Entry exists
        XCTAssertNotNil(journalManager.getJournalEntriesArray()[testJournalIndex])
        //Test that the Journal Manager deleted the test Journal Entry
        XCTAssertTrue(journalManager.deleteJournalEntryByIndex(id: testJournalIndex))
    }
    
    /**
     Test that Journal Manager can update a Journal Entry Field
     **/
    func testUpdateJournalFromJournalManager() {
        //If the test Journal Entry is not in the Manager, insert it
        if journalManager.getJournalEntryByKey(key: journalID1) == nil {
            //Create a Journal Entry for testing
            let journal:Journal = Journal(id: journalID1)
            //Add Journal, assume insertion was success as there is a separate test for inserting
            XCTAssertTrue(journalManager.addJournal(journal: journal))
        }
        
        //Get the test Journal Entry from the Manager
        var journalEntryTest:Journal? = journalManager.getJournalEntryByKey(key: journalID1)
        //Test that the test Journal Entry is not nil
        XCTAssertNotNil(journalEntryTest)
        //Update the note field in the test Journal Entry
        journalEntryTest!.note = "Updated"
        
        //Test that the Journal Manager is able to update the test Journal Entry
        XCTAssertTrue(journalManager.updateJournalyEntry(journal: journalEntryTest!))
        //Check that the update value and the value of the note fild in the Journal Manager are the same
        XCTAssertTrue(journalEntryTest!.note == journalManager.getJournalEntryByKey(key: journalID1)!.note)
    }
    
    /**
     Test that a test Journal Entry can be deleted.
     **/
    func testDeleteFromJournalManager() {
        //If the test Journal Entry is not in the Manager, insert it
        if journalManager.getJournalEntryByKey(key: journalID1) == nil {
            //Create a Journal Entry for testing
            let journal:Journal = Journal(id: journalID1)
            //Add Journal, assume insertion was success as there is a separate test for inserting
            XCTAssertTrue(journalManager.addJournal(journal: journal))
        }
        
        //Get the curren count of the Entries in the Journal Manager
        let journalEntriesCount:Int = journalManager.getAllJournalEntries()!.count
        
        //Test that Journal Manager is able to delete the test entry
        XCTAssertTrue(journalManager.deleteJournalEntryByKey(key: journalID1))
        //Test that the Count of the Journal Entries has decreased by 1
        XCTAssertTrue(journalManager.getAllJournalEntries()!.count == (journalEntriesCount - 1))
    }
    
    /**
     Test Business rule that a Journal with an empty note field cannot be added to the Journal Manager
     **/
    func testUnableToInsertEmptyNote() {
        //If the test Journal entry is in the JournalManager, delete it for this test
        if journalManager.getJournalEntryByKey(key: journalID1) != nil {
            XCTAssertTrue(journalManager.deleteJournalEntryByKey(key: journalID1))
        }
        
        //Create an invalid Journal Entry
        var journalInvalid:Journal = Journal(id: journalID1)
        journalInvalid.note = ""
        
        //Test that we are unable to insert the invalid Journal Entry
        XCTAssertFalse(journalManager.addJournal(journal: journalInvalid))
        //Test that the invalid Journal Entry is not in the Journal Manager
        XCTAssertNil(journalManager.getJournalEntryByKey(key: journalID1))
    }

    
}
