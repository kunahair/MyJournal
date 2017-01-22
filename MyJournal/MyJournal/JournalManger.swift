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
    
    init()
    {
        //self.journalEntries = FakeJournalEntries.getFakeJournalEntries()
        for i in 0...1 {
            let key = String(Int(NSDate().timeIntervalSince1970*1000) + i*1000)
            // create journal with a key that is the same with its key in the dictionary
            journalEntries.updateValue(Journal(id: key), forKey: key)
        }
    }
    
    //Get the JournalEntries Array
    func getJournalEntriesArray()->[Journal]
    {
        // return the values as array
        return [Journal](journalEntries.values)
    }
    
    //Get JournalEnties in a Dictionary, with Date as the Key
    func getJournalAsDictionary()->Dictionary<String, Journal>
    {
        return journalEntries
    }
    
    func getJournalEntriesCount()-> Int
    {
        return self.journalEntries.count
    }
    
    //Add a Journal Entry to the JournalEntries Array
    // 19Jan Ryan: add the tiemstamp to the journal obj when this addJournal func is called
    // the Journal object is modified accordingly
    mutating func AddJournal(note: String, music: String?, quote: String?, photo: String, weather: String, mood: String, date: String, location: String, favorite: Bool, coordinates: [Double])
    {
        let key = String(Int(NSDate().timeIntervalSince1970*1000))
        let journal = Journal(note: note, music: music, quote: quote, photo: photo, weather: weather, mood: mood, date: date, location: location, favorite: favorite, coordinates: coordinates, id: key)

        self.journalEntries.updateValue(journal, forKey: String(key))
    }

    //Delete a JournalEntry from JournalEntries Array, using the Array Index
    //Returns true if index and delete where valied, otherwise returns false
    // 19Jan Ryan: this func remains its functionality
    mutating func deleteJournalEntryByIndex(id: Int)->Bool
    {
        let journalArray = getJournalEntriesArray()
        let journalToRemove:Journal? = journalArray[id]
        // if the journal is found in the array, get its key/id
        if journalToRemove != nil
        {
            let journalID = journalToRemove!.id
            // means it can be removed, and is removed
            if journalEntries.removeValue(forKey: journalID) != nil {
                return true
            }
        }
        return false
    }
    
    // delete by journal dict key
    mutating func deleteJournalEntryByKey(key: String)->Bool {
        if journalEntries.removeValue(forKey: key) != nil {
            return true
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
 
    mutating func setJournalFavouriteByKey(key: String)->Bool {
        //let journalToLike:Journal? = journalEntries[key]
        if journalEntries[key] != nil { // when the key is found in the dictionary
            // set true to false, false to true
            journalEntries[key]!.favorite ? (journalEntries[key]!.favorite=false) : (journalEntries[key]!.favorite=true)
            return true
        }
        return false
    }
    
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
    
    func getJournalFavouriteByIndex(index: Int)->Journal? {

        // access by index
        return getJournalEntriesArray()[index]
    }

}
