//
//  FakeJournalEntries.swift
//  MyJournal
//
//  Created by Josh Gerlach on 19/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import Foundation

struct FakeJournalEntries
{
    
    static func getFakeJournalEntries()->[String: Journal]
    {
        var fakeJournalEntries = [String:Journal]()
        
        var journalEntry = Journal(note: "Keep you in the dark \n You know they all pretend\nKeep you in the dark\nAnd so it all began \nSend in your skeletons", music: "https://www.youtube.com/watch?v=SBjQ9tuuTJQ", quote: "Keep you in the dark, you know they all pretend", photo: "", weather: "cloudy", mood: "tired", date: "06/01/2017", location: "Upwey, Victoria, Australia", favorite: false, coordinates: [-37.904001,145.3160473], id: String(Date().timeIntervalSince1970))
        
        fakeJournalEntries[journalEntry.id] = journalEntry
        
        journalEntry = Journal(note: "Run and tell all of the Angels \n This could take all night \n Think I need a devil to help me get things right \n Hook me up a new revolution", music: "https://www.youtube.com/watch?v=eBG7P-K-r1Y", quote: "Make my way back home and I learn to fly", photo: "", weather: "sunny", mood: "peacful", date: "05/01/2017", location: "Melbourne, Victoria, Australia", favorite: true, coordinates: [-37.8200,144.9834], id: String(Date().timeIntervalSince1970))
        
        fakeJournalEntries[journalEntry.id] = journalEntry
        
        journalEntry = Journal(note: "How long, I\'v waited here for you \n Everlong \n Tonight, I throw myself into", music: "https://www.youtube.com/watch?v=1VQ_3sBZEm0", quote: "If everything could feel this real forever", photo: "", weather: "sunny", mood: "happy", date: "04/06/2016", location: "Melbourne, Victoria, Australia", favorite: true, coordinates: [-37.8251,144.9838], id: String(Date().timeIntervalSince1970))
        
        fakeJournalEntries[journalEntry.id] = journalEntry
        
        return fakeJournalEntries
    }
}
