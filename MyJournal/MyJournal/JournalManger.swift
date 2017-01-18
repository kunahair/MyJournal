//
//  JournalManger.swift
//  MyJournal
//
//  Created by XING ZHAO on 17/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import UIKit

class JournalManger: NSObject {
    static var journals = [Journal]()
    static var favJournals = [Journal]()
    
    class func AddJournal(note: String, music: String, quote: String, photo: String, weather: String, mood: String, date: String, location: String, favorite: Bool, coordinates: [Double]){
        var journal = Journal(note: note, music: music, quote: quote, photo: photo, weather: weather, mood: mood, date: date, location: location, favorite: favorite, coordinates: coordinates)
        journals.append(journal)
    }
    
    class func AddFavJournal(note: String, music: String, quote: String, photo: String, weather: String, mood: String, date: String, location: String, favorite: Bool, coordinates: [Double]){
        var favJournal = Journal(note: note, music: music, quote: quote, photo: photo, weather: weather, mood: mood, date: date, location: location, favorite: favorite, coordinates: coordinates)
        if favorite == true{
            favJournals.append(favJournal)
        }
    }
    
    class func DeleteJounal(id: Int){
        journals.remove(at: id)
    }
    
    class func GetJournal(id: Int) -> Journal{
        if(journals.count > 0){
                return journals[id]
        }
        return Journal()
    }

}
