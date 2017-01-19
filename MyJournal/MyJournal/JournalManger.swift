//
//  JournalManger.swift
//  MyJournal
//
//  Created by XING ZHAO on 17/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import UIKit

struct JournalManger {
    
    private var journalEntries:[Journal] = []
    
    init()
    {
        self.journalEntries = Array(repeating: Journal(), count: 10)
    }
    
    //Get the JournalEntries Array
    func getJournalEntriesArray()->[Journal]
    {
        return journalEntries
    }
    
    //Get JournalEnties in a Dictionary, with Date as the Key
    func getJournalAsDictionary()->Dictionary<String, Journal>
    {
        var journalDictionary = [String: Journal]()
        
        for journal in journalEntries
        {
            journalDictionary[journal.date] = journal
        }
        
        return journalDictionary
    }
    
    func getJournalEntriesCount()-> Int
    {
        return self.journalEntries.count
    }
    
    //Add a Journal Entry to the JournalEntries Array
    mutating func AddJournal(note: String, music: String, quote: String, photo: String, weather: String, mood: String, date: String, location: String, favorite: Bool, coordinates: [Double])
    {
        let journal = Journal(note: note, music: music, quote: quote, photo: photo, weather: weather, mood: mood, date: date, location: location, favorite: favorite, coordinates: coordinates)
        self.journalEntries.append(journal)
    }
    
    //Delete a JournalEntry from JournalEntries Array, using the Array Index
    //Returns true if index and delete where valied, otherwise returns false
    mutating func deleteJounalEntryByIndex(id: Int)->Bool
    {
        let removedJournalEntry:Journal? = self.journalEntries.remove(at: id)
        if removedJournalEntry != nil
        {
            return true
        }
        return false
    }
    
    //Get a Journal Entry from Array by index
    //Returns a Journal Entry if found, returns a Blank Journal if not found
    //NOTE: Should change to Optional
    func getJournalEntryByIndex(id: Int) -> Journal
    {
        if(self.journalEntries.count > 0)
        {
                return self.journalEntries[id]
        }
        return Journal()
    }
    
    //Get a Journal Entry and its Array Index by Date
    //Returns a Tuple (index: Int, journal: Journal) returns nil if not found
    func getJournalEntryAndIndexByDate(date: String)->(index: Int, journal: Journal)?
    {
        for (index, journal) in journalEntries.enumerated()
        {
            if journal.date == date
            {
                return (index, journal)
            }
        }
        return nil
    }
    
    

}
