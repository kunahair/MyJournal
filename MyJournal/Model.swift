//
//  Model.swift
//  MyJournal
//
//  Created by Josh Gerlach on 12/01/2017.
//  Copyright © 2017 LegDay. All rights reserved.
//

import Foundation

class Model{
    
    
    init()
    {
        
        //The Latitude of rmit university is -37.8087. The Longitude of rmit university is 144.9637
        
        //Get current weather from OpenWeatherMap API and add to current Weather Object
        let openWeatherMap = OpenWeatherMap()
        let currentWeather:Weather = openWeatherMap.getCurrentWeather(lat: 140.0, lon: 137.0)
        
        //Get User Readable Address from OpenStreet API and load into Location Object
        let openStreetMap = OpenStreetMap()
        var location:Location = Location()
        location.address = openStreetMap.getReadableAddress(lat: -37.8087, lon: 144.9637)
        
        print(currentWeather.description)
    }
    
}
