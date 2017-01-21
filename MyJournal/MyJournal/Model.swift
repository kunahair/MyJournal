//
//  Model.swift
//  MyJournal
//
//  Created by Josh Gerlach on 12/01/2017.
//  Copyright © 2017 LegDay. All rights reserved.
//

import Foundation

class Model{
    
    static let getInstance = Model()
    
//    var journalArray:Array<Journal> = []
//    static var journalCurrentEntry:Journal = Journal()
    
    var journalManager:JournalManger = JournalManger()
    private let _moodCases: [String] = ["happy", "sad", "okay", "tired", "peaceful"]
    
    private init()
    {
        
        //The Latitude of rmit university is -37.8087. The Longitude of rmit university is 144.9637
        
//        self.journalArray = Array(repeating: Journal(), count: 10)
        
    }
    
//    func getJournalEntriesArray()->Array<Journal>
//    {
//        return journalArray
//    }
//    
//    func getJournalEntryByDate(date: String)->Journal?
//    {
//        for journalEntry in journalArray
//        {
//            if journalEntry.date == date
//            {
//                return journalEntry
//            }
//        }
//        
//        return nil
//    }
//    
//    func getJournalIndexByDate(date: String)->Int
//    {
//        for (index, journalEntry) in journalArray.enumerated()
//        {
//            if journalEntry.date == date{
//                return index
//            }
//        }
//        return -1
//    }
    
    
    
    /**
     User accesible function to get the weather from API
     Returns a Weather Object
    **/
    func getWeather(lat:Float, lon:Float)->Weather
    {
        //Get current weather from OpenWeatherMap API and add to current Weather Object
        let openWeatherMap = OpenWeatherMap()
        return openWeatherMap.getCurrentWeather(lat: 140.0, lon: 137.0)
    }
    
    /**
     User accessible function to get a User Readable location
     Returns a Location Object
    **/
    func getReadableAddress(lat:Float, lon:Float)->Location
    {
        //Get User Readable Address from OpenStreet API and load into Location Object
        let openStreetMap = OpenStreetMap()
        var location:Location = Location()
        location.lat = lat
        location.lon = lon
        location.address = openStreetMap.getReadableAddress(lat: -37.8087, lon: 144.9637)
        return location
    }
    
    /**
     User facing function to get device location.
     Ability to be extended using Chain of Responsibility, eg try GPS, then try by IP address...
     Returns a Location Object or Throws an error
    **/
    func getLocation() throws ->Location
    {
        let deviceLocation:DeviceLocation = DeviceLocation()
        
        var location:Location?
        
        //Test for device location, catch errors and re-throw them up to the caller
        do {
            location = try deviceLocation.getDeviceLocation()
        } catch DeviceLocationError.locationNotFound {
            throw DeviceLocationError.locationNotFound
        } catch DeviceLocationError.permissionDenied {
            throw DeviceLocationError.permissionDenied
        } catch {
            throw DeviceLocationError.locationError
        }
        
        return location!
    }
    
    //get current date in custom format
    // moved from view
    func getCurrentDate()->String{
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "DD-MM-YY"
        let dateStr = formatter.string(from: currentDate)
        return dateStr
    }
    
    // return passible mood selections in an array
    func getMoodArray()->[String] {
        return self._moodCases
    }
    
    static func getUserReadableDate(date: Date)->String
    {
        let deviceDate:DeviceDate = DeviceDate(date: date)
        return deviceDate.readableDate
    }
    
}
