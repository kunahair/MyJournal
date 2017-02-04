//
//  JournalDatabaseAdapter.swift
//  MyJournal
//
//  Created by Josh Gerlach on 28/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import Foundation

/**
 Adapter (maybe more of a wrapper) to convert a Jounal Entry into a JournalDB object that encapuslates the same data, but it compatible with the database
 Does both conversions to and from databse
 Also contains a function to convert a boolean to an Int (conveinience for favourite update)
 **/
struct JournalDatabaseAdapter {
    
    static func convertForDatabase(journal: Journal)->JournalDB
    {
        var journalDB:JournalDB = JournalDB()
        
        //Capture all the data that is common to both Journal and JournalDB
        journalDB.id = journal.id
        journalDB.note = journal.note
        journalDB.date = journal.date
        journalDB.location = journal.location
        journalDB.mood = journal.mood
        journalDB.music = journal.music
        journalDB.photo = journal.photo
        journalDB.quote = journal.quote
        journalDB.weather = journal.weather
        
        //Convert a favourite boolean into an Int
        if journal.favorite {
            journalDB.favorite = 1
        }else{
            journalDB.favorite = 0
        }
        
        //Convert the coordinates array [Double] into a JSON like string to store in database
        journalDB.coordinates = "{\"coord\":{\"lat\":" + String(journal.coordinates[0]) + ",\"lon\":" + String(journal.coordinates[1]) + "}}"
        
        //Check if there is a videoURL, if there is the save the string value into the database
        if journal.videoURL != nil {
            journalDB.videoURL = journal.videoURL!.absoluteString
        }
        
        //Check if there is a recordName, if there is, save the string value into the database
        if journal.recordName != nil {
            journalDB.recordName = journal.recordName!
        }
        
        //Return the database ready object
        return journalDB
    }
    
    /**
     Convert a JournalDB object (data pulled from database) into a usable Journal Object
    **/
    static func convertFromDatabase(journalDB: JournalDB)->Journal
    {
        //Create a default Journal object, loading in data that can be used an placeholders to be filled in
        var journal:Journal = Journal(note: journalDB.note, music: journalDB.music, quote: journalDB.quote, photo: journalDB.photo, weather: journalDB.weather, mood: journalDB.mood, date: journalDB.date, location: journalDB.location, favorite: false, coordinates: [0.0, 0.0], id: journalDB.id, record: nil, video: nil)
        
        //If the favourite is set to 1, set it to true in the Journal Object
        if journalDB.favorite == 1{
            journal.favorite = true
        }
        
        //Convert coordinates from String into JSON
        let coordinatesJSON = JSON.init(parseJSON: journalDB.coordinates)
        
        //Extract coordinates from JSON into Journal
        journal.coordinates[0] = coordinatesJSON["coord"]["lat"].doubleValue
        journal.coordinates[1] = coordinatesJSON["coord"]["lon"].doubleValue
        
        //If present, get the videoURl
        if journalDB.videoURL != "" {
            journal.videoURL = NSURL(string: journalDB.videoURL) as URL?
        }
        
        //If present, get the recordName
        if journalDB.recordName != "" {
            journal.recordName = journalDB.recordName
        }
        
        //Return the converted Journal object
        return journal
    }
    
    /**
     Convert a Favourite Boolean into a Int for use in the database
    **/
    static func convertFavourite(favorite: Bool)->Int
    {
        return favorite ? 1 : 0
    }
}
