//
//  JournalManger.swift
//  MyJournal
//
//  Created by XING ZHAO on 17/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import UIKit

struct JournalManger {
    
    private var journalEntries:[String:Journal] = [:]
    
    //Manager for the Database
    fileprivate var journalDBManager:JournalDBManager = JournalDBManager()
    
    init()
    {
        
        //let _ = journalDBManager.removeDatabaseFile()
        if journalDBManager.initialiseDatabase() {
            self.journalEntries = journalDBManager.getAllJournalEntries()!
        }
    }
    
    //Get the JournalEntries Array, sorted by date
    func getJournalEntriesArray()->[Journal]
    {
        var journalEntryArray = [Journal](journalEntries.values)
        journalEntryArray = journalEntryArray.sorted(by: {$0.id > $1.id})
        //Return sorted array
        return journalEntryArray

    }
    
    //Get JournalEnties in a Dictionary, with Date as the Key
    func getJournalAsDictionary()->Dictionary<String, Journal>
    {
        return journalEntries
    }
    
    //Get count of Journal Entries in Dictionary (memory)
    func getJournalEntriesCount()-> Int
    {
        return self.journalEntries.count
    }
    
    //Add a Journal Entry to the JournalEntries Array
    // 19Jan Ryan: add the tiemstamp to the journal obj when this addJournal func is called
    // the Journal object is modified accordingly
    // Josh: Try to add to database first, if successful, add to Dictionary
    mutating func AddJournal(note: String, music: String?, quote: String?, photo: String, weather: String, mood: String, date: String, location: String, favorite: Bool, coordinates: [Double], recordURL: URL?, videoURL: URL?)
    {
        let key = String(Int(NSDate().timeIntervalSince1970*1000))
        let journal = Journal(note: note, music: music, quote: quote, photo: photo, weather: weather, mood: mood, date: date, location: location, favorite: favorite, coordinates: coordinates, id: key, record: recordURL, video: videoURL)

        if journalDBManager.saveJournalEntryToDatabase(journal: journal){
            self.journalEntries.updateValue(journal, forKey: String(key))
        }
    }

    //Delete a JournalEntry from JournalEntries Array, using the Array Index
    //Returns true if index and delete where valied, otherwise returns false
    // 19Jan Ryan: this func remains its functionality
    // Josh: Remove from database, if successful remove from Dictionary
    mutating func deleteJournalEntryByIndex(id: Int)->Bool
    {
        let journalArray = getJournalEntriesArray()
        let journalToRemove:Journal? = journalArray[id]
        // if the journal is found in the array, get its key/id
        if journalToRemove != nil
        {
            let journalID = journalToRemove!.id
            // means it can be removed, and is removed
            return deleteJournalEntryByKey(key: journalID)
        }
        return false
    }
    
    // delete by journal dict key
    //First try to delete from the database, if successful then remove from the dictionary
    mutating func deleteJournalEntryByKey(key: String)->Bool {
        
        if journalDBManager.deleteJournalEntryFromDatabaseById(id: key){
            if journalEntries.removeValue(forKey: key) != nil {
                return true
            }
        }
        return false
    }
    
    // get journal entry from Dict by key
    func getJournalEntryByKey(key: String) -> Journal? {
        return journalEntries[key]
    }
    
    
    //Get a Journal Entry from Array by index
    //Returns a Journal Entry if found, returns a Blank Journal if not found
    //NOTE: Should change to Optional
    // 19Jan Ryan: this func remains its functionality,
    // it converts the current dictionary into an array and return it
    func getJournalEntryByIndex(id: Int) -> Journal
    {
        if(self.journalEntries.count > 0)
        {
            let journalArray = getJournalEntriesArray()
                return journalArray[id]
        }
        return Journal(id: String(Int(NSDate().timeIntervalSince1970)))
    }

    //Get a Journal Entry and its Array Index by Date
    //Returns a Tuple (index: Int, journal: Journal) returns nil if not found
    func getJournalEntryAndIndexByDate(date: String)->(index: Int, journal: Journal)?
    {
        let journalArray = getJournalEntriesArray()
        for (index, journal) in journalArray.enumerated()
        {
            if journal.date == date
            {
                return (index, journal)
            }
        }
        return nil
    }
 
    //Toogle Journal Favourite in database and in Dictionary
    //Return boolean to indicate completion
    mutating func setJournalFavouriteByKey(key: String)->Bool {
        //Get Journal from Model Dictionary
        var journalEntry:Journal? = journalEntries[key]
        
        //If the entry exists, toggle the favourite value of the pulled entry
        //Then try to modify the Database first
        //If it is successful, update the Dictionary
        if journalEntry != nil {
            journalEntry?.favorite = !(journalEntry?.favorite)!
            if journalDBManager.updateJournalEntryFavourite(id: key, favourite: (journalEntry?.favorite)!)
            {
                journalEntries[key]?.favorite = (journalEntry?.favorite)!
                return true
            }
        }
        return false
    }
    
    //Get list of Journal Entries that are favourited
    //Return as an array
    func getJournalFavouriteArray()->[Journal] {
        let journalArray = getJournalEntriesArray()
        var favouriteArray: [Journal] = []
        for journal in journalArray {
            if journal.favorite { // if it is favourite
                // add to the favs
                favouriteArray.append(journal)
            }
        }
        return favouriteArray
    }
    
    //Get Journal Entry by Index convienience function
    func getJournalFavouriteByIndex(index: Int)->Journal? {

        // access by index
        return getJournalEntriesArray()[index]
    }

}
