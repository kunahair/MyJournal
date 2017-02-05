//
//  Model.swift
//  MyJournal
//
//  Created by Josh Gerlach on 12/01/2017.
//  Copyright © 2017 LegDay. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class Model{
    
    static let getInstance = Model()
    
    var journalManager:JournalManger = JournalManger()
    var fileOpManager: FileOpManager = FileOpManager()
    
    private let _moodCases: [String] = ["happy", "sad", "okay", "tired", "peaceful"]
    // for handling locations
    let locationManager = CLLocationManager()
    
    private init()
    {
        
        //The Latitude of rmit university is -37.8087. The Longitude of rmit university is 144.9637
        
//        self.journalArray = Array(repeating: Journal(), count: 10)
        
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
    func getCurrentDateSec()->String{
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "YY-MM-dd-HH-MM-SS"
        let dateStr = formatter.string(from: currentDate)
        return dateStr
    }
    
    /**
     Get current device date that is User Readable
     Return a String that is a User Readable representation of the device date
    **/
    func getCurrentDate()->String{
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YY"
        let dateStr = formatter.string(from: currentDate)
        return dateStr
    }
    
    // Ryan 26Jan, added this functino to return a unique file name with given extension type and currentDateSec()
    func getCurrentDateSecFilename(extensionType: String) -> String {
        let filename = self.getCurrentDateSec().appending(extensionType)
        return filename
    }
    
    
    // return passible mood selections in an array
    func getMoodArray()->[String] {
        return self._moodCases
    }
    
    //Get current directory path
    func getCurrentDirectory()->NSString{
        let paths: NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDir: NSString = paths.object(at: 0) as! NSString
        
//        let photoPath  = documentsDir.appendingPathComponent(photoName)
        return documentsDir
    }
    
    /**
     Get document from Documents Directory.
     Return path of selected filename as a String
    **/
    func getFilePathFromDocumentsDirectory(filename: String)->String
    {
        let documentsDir:NSString = getCurrentDirectory()
        return documentsDir.appendingPathComponent(filename)
    }

    /**
     Get a moods index in the Mood Array by name
     Return the index that the mood is in as an Integer, returns -1 if no mood was found that matches name
     
     NOTE: Could be made an optional, but you have to keep track of, unpack and do extra tests, easier and faster to test an Int and not for nil
    **/
    func getMoodByName(name: String)->Int
    {
        //Get the Mood Array
        let moodArray = getMoodArray()
        //Loop through each mood in array and test for the name provided, when it is found, return the index
        for (index, mood) in moodArray.enumerated() {
            if mood == name {
                return index
            }
        }
        //Return -1, error, as default
        return -1
    }
    
    static func getUserReadableDate(date: Date)->String
    {
        let deviceDate:DeviceDate = DeviceDate(date: date)
        return deviceDate.readableDate
    }
    
    
    /*
        Changes -Ryan -25Jan
        Map display related functions
     */
    // return the coordinate object as the center for map display
    func getMapCenter(location: [Double]) -> CLLocationCoordinate2D {
        let lat = location[0]
        let lon = location[1]
        
        let coordinate = CLLocationCoordinate2DMake(lat, lon)
        
        return coordinate
    }
    
    // returns a region to load the map, gracefully handles a Journal, return a tuple with enough info to display on map
    func getMapInfo(journal: Journal)->(MKCoordinateRegion, MKPointAnnotation) {
        // get coord from the Journal and pass to func
        let coordinates = getMapCenter(location: journal.coordinates)
        // set up zoom
        let span = MKCoordinateSpanMake(0.4, 0.4)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        
        // create annotation
        let ann = MKPointAnnotation()
        ann.coordinate = coordinates
        ann.title = journal.date
        ann.subtitle = journal.location
        return (region, ann)
    }
}
