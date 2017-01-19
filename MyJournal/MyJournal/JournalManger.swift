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
        //self.journalEntries = Array(repeating: Journal(), count: 10)
        self.journalEntries = FakeJournalEntries.getFakeJournalEntries()
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
    
    func getJournalEntriesFromLastSevenDays()->[Journal]
    {
        var journalsLastSevenDays:[Journal] = [Journal]()
        
        var date = Date()
        date.addTimeInterval((60.0 * 60.0 * 24.0 * 7.0) * -1.0)
        let formatter = DateFormatter()
        formatter.dateFormat = "DD/MM/YYYY"
        var dateStr = formatter.string(from: date)
        
        for journal in self.journalEntries
        {
            if journal.date >= dateStr
            {
                journalsLastSevenDays.append(journal)
            }
        }
        
        return journalsLastSevenDays
    }
    
    func getJournalEntriesFromLastFourteenDays()->[Journal]
    {
        var journalsLastFourteenDays:[Journal] = [Journal]()
        
        var dateFourteenDaysAgo = Date()
        dateFourteenDaysAgo.addTimeInterval((60.0 * 60.0 * 24.0 * 14.0) * -1.0)
        
        var dateSevenDaysAgo = Date()
        dateSevenDaysAgo.addTimeInterval((60.0 * 60.0 * 24.0 * 7.0) * -1.0)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "DD/MM/YYYY"
        
        let dateFourteenDaysAgoStr = formatter.string(from: dateFourteenDaysAgo)
        let dateSevenDaysAgoStr = formatter.string(from: dateSevenDaysAgo)
        
        for journal in self.journalEntries
        {
            if journal.date >= dateFourteenDaysAgoStr && journal.date < dateSevenDaysAgoStr
            {
                journalsLastFourteenDays.append(journal)
            }
        }
        
        return journalsLastFourteenDays
    }
    
    func getJournalEntriesBeyondFourteenDaysAgo()->[Journal]
    {
        var journalsLastFourteenDays:[Journal] = [Journal]()
        
        var dateFourteenDaysAgo = Date()
        dateFourteenDaysAgo.addTimeInterval((60.0 * 60.0 * 24.0 * 14.0) * -1.0)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "DD/MM/YYYY"
        
        let dateFourteenDaysAgoStr = formatter.string(from: dateFourteenDaysAgo)
        
        for journal in self.journalEntries
        {
            if journal.date < dateFourteenDaysAgoStr
            {
                journalsLastFourteenDays.append(journal)
            }
        }
        
        return journalsLastFourteenDays
    }
    

}
