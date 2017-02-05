//
//  ManagerProtocol.swift
//  MyJournal
//
//  Created by Josh Gerlach on 29/1/17.
//  Copyright © 2017 Xing. All rights reserved.
//

import Foundation

/**
 Protocol to manage the common functionality between the Database and Memory Model
 This makes for easier code maintainablity, plus a chance to show off :P
**/
protocol JournalManagerProtocol {
    
    //Add a Journal Entry to Model
    mutating func addJournal(journal: Journal)->Bool
    
    //Get all Journal Entries in Model, return a Dictionary of results
    mutating func getAllJournalEntries()->[String: Journal]?
    
    //Get a single entry from the Model by key (id/timestamp)
    mutating func getJournalEntryByKey(key: String)->Journal?
    
    //Toogle the value of a given Journal Entry (by key)
    mutating func toggleJournalFavouriteByKey(key: String)->Bool
    
    //Delte a Journal entry from the Model by key (id/timestamp)
    mutating func deleteJournalEntryByKey(key: String)->Bool
    
    //Update a Journal Entry parsing the entire Journal to update
    mutating func updateJournalyEntry(journal: Journal)->Bool
}
