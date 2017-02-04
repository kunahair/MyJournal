//
//  JournalManger.swift
//  MyJournal
//
//  Created by XING ZHAO on 17/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//
import UIKit

struct JournalManger: JournalManagerProtocol {
    
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
    
    /**
     Protocol function to add journal to database, then when completed, add to Dictionary
     Returns success of insertion with a boolean
     **/
    mutating func addJournal(journal: Journal) -> Bool {
        if journalDBManager.addJournal(journal: journal){
            self.journalEntries.updateValue(journal, forKey: String(journal.id))
            return true
        }
        return false
    }
    
    /**
     Add a Journal Entry to the JournalEntries Array
     19Jan Ryan: add the tiemstamp to the journal obj when this addJournal func is called
     the Journal object is modified accordingly
     Josh: Try to add to database first, if successful, add to Dictionary
     Josh: Use protocol function to do insertion, this is a overloaded function that takes raw data and converts to Journal
     **/
    mutating func addJournal(note: String, music: String?, quote: String?, photo: String, weather: String, mood: String, date: String, location: String, favorite: Bool, coordinates: [Double], recordName: String?, videoURL: URL?) -> Bool
    {
        //Generate key and create Journal Entry
        let key = String(Int(NSDate().timeIntervalSince1970*1000))
        let journal = Journal(note: note, music: music, quote: quote, photo: photo, weather: weather, mood: mood, date: date, location: location, favorite: favorite, coordinates: coordinates, id: key, record: recordName, video: videoURL)
        
        //Add to database and Dictionary, return the result
        return addJournal(journal: journal)
    }
    
    //Get JournalEnties in a Dictionary, with Date as the Key
    mutating func getAllJournalEntries() -> [String : Journal]? {
        return journalEntries
    }
    
    //Get the JournalEntries Array, sorted by date
    func getJournalEntriesArray()->[Journal]
    {
        var journalEntryArray = [Journal](journalEntries.values)
        journalEntryArray = journalEntryArray.sorted(by: {$0.id > $1.id})
        //Return sorted array
        return journalEntryArray
        
    }
    
    //Get count of Journal Entries in Dictionary (memory)
    func getJournalEntriesCount()-> Int
    {
        return self.journalEntries.count
    }
    
        /**
     Get journal entry from Dict by key
     Check that the entry exists in the database, then get the Dictionary Journal entry if it does
     Returns nil if not in dictionary, otherwise returns the valid Journal Entry
     **/
    mutating func getJournalEntryByKey(key: String) -> Journal? {

//        return journalDBManager.getJournalEntryByKey(key: key)
//        if journalDBManager.getJournalEntryByKey(key: key) == nil{
//            return nil
//        }
//        
        return journalEntries[key]
    }
    
    /**
     Get a Journal Entry from Array by index
     Returns a Journal Entry if found, returns a Blank Journal if not found
     NOTE: Should change to Optional
     19Jan Ryan: this func remains its functionality,
     it converts the current dictionary into an array and return it
     **/
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
    
    mutating func updateJournalEntry(id: String, note: String, music: String?, quote: String?, photo: String, weather: String, mood: String, date: String, location: String, favorite: Bool, coordinates: [Double], recordName: String?, videoURL: URL?) -> Bool
    {
        var journal:Journal = Journal(id: id)
        journal.note = note
        journal.photo = photo
        journal.weather = weather
        journal.mood = mood
        journal.date = date
        journal.location = location
        journal.favorite = favorite
        journal.coordinates = coordinates
        journal.recordName = recordName
        journal.videoURL = videoURL
        
        if music != nil {
            journal.music = music!
        }
        
        if quote != nil {
            journal.quote =  quote!
        }
        
        
        return updateJournalyEntry(journal: journal)
    }
    
    mutating func updateJournalyEntry(journal: Journal) -> Bool {
        if journalDBManager.updateJournalyEntry(journal: journal)
        {
            journalEntries[journal.id] = journal
            return true
        }
        return false
    }
    
    /**
     Toogle Journal Favourite in database and in Dictionary
     Return boolean to indicate completion
     **/
    mutating func toggleJournalFavouriteByKey(key: String) -> Bool {
        //Get Journal from Model Dictionary
        var journalEntry:Journal? = journalEntries[key]
        
        //If the entry exists, toggle the favourite value of the pulled entry
        //Then try to modify the Database first
        //If it is successful, update the Dictionary
        if journalEntry != nil {
            //journalEntry?.favorite = !(journalEntry?.favorite)!
            if journalDBManager.toggleJournalFavouriteByKey(key: key)
            {
                journalEntries[key]?.favorite = !(journalEntry?.favorite)!
                return true
            }
        }
        return false
    }
    
    /**
     Delete a JournalEntry from JournalEntries Array, using the Array Index
     Returns true if index and delete where valied, otherwise returns false
     19Jan Ryan: this func remains its functionality
     Josh: Remove from database, if successful remove from Dictionary
     Josh: conveinience function to remove by index from converted Dictionary to Array
     **/
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
    
    /**
     Delete Journal Entry by Key (timestamp)
     First try to delete from the database, if successful then remove from the dictionary
     Uses protocol delete function
     **/
    mutating func deleteJournalEntryByKey(key: String)->Bool {
        
        if journalDBManager.deleteJournalEntryByKey(key: key){
            if journalEntries.removeValue(forKey: key) != nil {
                return true
            }
        }
        return false
    }
    
}
