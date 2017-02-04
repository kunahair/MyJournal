//
//  Journay.swift
//  MyJournal
//
//  Created by Yuanqing Jiang on 15/01/2017.
//  Copyright © 2017 LegDay. All rights reserved.
//

import Foundation

struct Journal {
    private var _note: String
    private var _music: String               // HyperLink String
    private var _quote: String
    private var _photo: String
    private var _weather: WeatherEnum        // Enum Object <- extracted from JSON String
    private var _mood: MoodEnum              // Enum Object <- extracted from JSON String
    private var _date: String                // Readable date <- converted from UNIX Date Object
    private var _location: String            // JSON String
    private var _favorite:Bool
    private var _coordinates: [Double]
    private var _id: String
    private var _recordName: String!
    private var _videoURL: URL!
    // Default empty constructor for dummy data testing
    init(id: String) {
        _note = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut rutrum enim tortor. Etiam consequat fringilla velit, at sollicitudin leo pretium nec. Sed porttitor, mi in condimentum convallis, nibh dui congue nisl, ut pharetra massa nisl sit amet mauris. Ut fermentum, enim vitae fringilla eleifend, nisl ex dignissim dui, eu sollicitudin ligula ex nec diam. Curabitur elementum laoreet elit, sit amet iaculis leo eleifend eu. Curabitur vel orci ut tortor convallis bibendum. Maecenas malesuada, metus elementum vehicula luctus, purus sapien accumsan augue, a feugiat nunc velit ut elit. \nVivamus auctor congue nulla, vitae sollicitudin turpis euismod non. Pellentesque eu ullamcorper nisl, at imperdiet quam. Etiam efficitur arcu lectus, eget suscipit turpis imperdiet sit amet. Nam suscipit risus nisl, quis sodales est dignissim non. Vivamus convallis elit eget felis ornare, a rhoncus est pretium. Pellentesque ut pellentesque sem, non viverra est. Nunc rutrum lacinia justo eu facilisis. \nVivamus ut sapien fermentum nulla congue aliquet sit amet ut augue. Aliquam vel feugiat eros, a tincidunt sem. Fusce ligula elit, gravida molestie ultrices vitae, tristique ut dui. Fusce ac euismod velit. Sed aliquet sodales ligula et tincidunt. Fusce condimentum volutpat mollis. Maecenas ullamcorper mattis ex, id tempus eros rutrum non. Vivamus sed urna lectus."
        
        _music = "horse.mp3"
        
        _quote = "You can do anything, but not everything. \n—David Allen"
        
        _photo = "defaultphoto"
        
        _weather = WeatherEnum()
        
        _mood = MoodEnum()
        
        _date = "DD/MM/YYYY"
        
        _location = "default loc"
        
        _favorite = true
        
        _coordinates = [-37.6, 144.0]
        
        _id = id
        
        
    }
    
    // Sepecific constructor
    init(note: String, music: String?, quote: String?, photo: String, weather: String, mood: String, date: String, location: String, favorite: Bool,coordinates:[Double], id: String, record: String?, video: URL?) {
        
        // check for nil values
        _music = music==nil ? "No Music" : music!
        _quote = quote==nil ? "No Quote" : quote!
        _recordName = record==nil ? nil : record!
        _videoURL = video==nil ? nil : video!
        
        // Assignments
        _note = note; _photo = photo; _date = date; _location = location; _favorite = favorite;_coordinates = coordinates; _id = id
        
        _weather = WeatherEnum(weather: weather)!
        _mood = MoodEnum(mood: mood)!
        
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
            self._weather.description = newWeather
        }
    }
    
    var weatherEmoji: String {
        get {
            return self._weather.emoji
        }
        set(newWeather) {
            self._weather.description = newWeather
        }
    }
    
    var mood: String {
        get {
            return self._mood.description
        }
        set(newMood) {
            self._mood.description = newMood
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
    
    var favorite: Bool {
        get {
            return self._favorite
        }
        set(newFavorite) {
            self._favorite = newFavorite
        }
    }
    
    var coordinates:[Double]
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
    }
    
    var recordName: String? {
        get {
            return self._recordName
        }
        set(url) {
            self._recordName = url
        }
    }
    
    var videoURL: URL? {
        get {
            return self._videoURL
        }
        set(url) {
            self._videoURL = url
        }
    }

    /*
        Utility functions, like date convertion when saving new date, location convertions and etc,
        I guess the main point of having these functions will be that when access these functoins, the output will be user readable for the front end UI. this way when directly accessing the variables in this object from the data model it will return data-friendly strings.
        So essentially all convertions are encapsulated and done within the object itself, I personally find it neat and easy to work with from a design point of view.
        --- Ryan over and out ;)
     */
    
    // for accessing photos from the front

    // accessing location
}
