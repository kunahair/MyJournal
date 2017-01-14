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
        let openWeatherMap = OpenWeatherMap()
        let currentWeather:Weather = openWeatherMap.getCurrentWeather(lat: 140.0, lon: 137.0)
        
        //        print(currentWeather)
    }
    
}
