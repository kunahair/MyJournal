//
//  JournalDB.swift
//  MyJournal
//
//  Created by Josh Gerlach on 28/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import Foundation

/**
 Struct to hold a Journal Object that is compatible with the databse
 This is mostly type converting
 Like booleans to ints, arrays to JSON like string and such
 **/
struct JournalDB {
        private var _note: String
        private var _music: String               // HyperLink String
        private var _quote: String
        private var _photo: String
        private var _weather: String        // Enum Object <- extracted from JSON String
        private var _mood: String             // Enum Object <- extracted from JSON String
        private var _date: String                // Readable date <- converted from UNIX Date Object
        private var _location: String            // JSON String
        private var _favorite: Int
        private var _coordinates: String
        private var _id: String
        private var _videoURL: String
        private var _recordName: String
        
        init()
        {
            self._id = ""
            self._note = ""
            self._music = ""
            self._quote = ""
            self._photo = ""
            self._weather = ""
            self._mood = ""
            self._date = ""
            self._location = ""
            self._favorite = 0
            self._coordinates = ""
            self._videoURL = ""
            self._recordName = ""
            
        }
        
        /*
         setters and getters in a nice manner
         For Those String values that needs convertions:
         1. user readable data can be returned using the utility functions down in this file
         2. these computed variable returns the porperties directly, which means that the local variables in this object shall contains the 'raw' data strings, like original JSON strings
         */
        var note: String {
            get {
                return self._note
            }
            set(newNote) {
                self._note = newNote
            }
        }
        
        var music: String {
            get {
                return self._music
            }
            set(newMusic) {
                self._music = newMusic
            }
        }
        
        var quote: String {
            get {
                return self._quote
            }
            set(newQuote) {
                self._quote = newQuote
            }
        }
        
        var photo: String {
            get {
                return self._photo
            }
            set (newPhoto) {
                self._photo = newPhoto
            }
        }
        
        var weather: String {
            get {
                return self._weather.description
            }
            set(newWeather) {
                self._weather = newWeather
            }
        }
        
        var mood: String {
            get {
                return self._mood.description
            }
            set(newMood) {
                self._mood = newMood
            }
        }
        
        var date: String {
            get {
                return self._date
            }
            set(newDate) {
                self._date = newDate
            }
        }
        
        var location: String {
            get {
                return self._location
            }
            set(newLocation) {
                self._location = newLocation
            }
        }
        
        var favorite: Int {
            get {
                return self._favorite
            }
            set(newFavorite) {
                self._favorite = newFavorite
            }
        }
        
        var coordinates:String
            {
            get{
                return self._coordinates
            }
            set(coordinates){
                self._coordinates = coordinates
            }
        }
        
        var id:String {
            get {
                return self._id
            }
            set (id){
                self._id = id
            }
        }
        
        var recordName: String {
            get {
                return self._recordName
            }
            set(name) {
                self._recordName = name
            }
        }
        
        var videoURL: String {
            get {
                return self._videoURL
            }
            set(url) {
                self._videoURL = url
            }
        }
        
}

