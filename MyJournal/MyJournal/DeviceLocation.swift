//
//  DeviceLocation.swift
//  MyJournal
//
//  Created by Josh Gerlach on 14/01/2017.
//  Copyright © 2017 LegDay. All rights reserved.
//

import Foundation
import CoreLocation

/**
 Class that is responsible for handeling all the Device Location services
 **/
class DeviceLocation: NSObject, CLLocationManagerDelegate
{
    let locationManager = CLLocationManager()
 
    override init() {
        super.init()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
    }
    
    /**
     User accessible function that gets the Device Locaion from the GPS signal
     Returns Location Object
    **/
    func getDeviceLocation() throws ->Location
    {
        //Test if location services are enabled,
        //If not, throw a permission denied error
        if CLLocationManager.locationServicesEnabled() {
            //Setup delegation, accuracy and update the location
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            
            //Check location manager properties,
            //if any are nil, throw a location not found error
            if locationManager.location == nil
            {
                throw DeviceLocationError.locationNotFound
            }
            if (locationManager.location?.coordinate.latitude == nil)
            {
                throw DeviceLocationError.locationNotFound
            }
            if (locationManager.location?.coordinate.longitude == nil)
            {
                throw DeviceLocationError.locationNotFound
            }
            
            //Create new Location Object, load the locations into it then return
            var location:Location = Location()
            location.lat = Float((locationManager.location?.coordinate.latitude)!)
            location.lon = Float((locationManager.location?.coordinate.longitude)!)
            
            //Stop location tracking as it is not nessessary to have constant updating
            //Also saves battery :P
            locationManager.stopUpdatingLocation()
            
            //throw DeviceLocationError.locationNotFound
            return location
        }else{
            //Otherwise, thow a permission denied error
            throw DeviceLocationError.permissionDenied
        }
        
    }
}
