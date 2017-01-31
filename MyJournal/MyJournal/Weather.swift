//
//  Weather.swift
//  MyJournal
//
//  Created by Josh Gerlach on 12/01/2017.
//  Copyright © 2017 LegDay. All rights reserved.
//

import Foundation

/**
 Weather struct to store all information about Weather from API
 Return separated by OpenWeatherMap JSON keys
 **/
struct Weather {
    
    //System information (does not relate to Weather directly, admin purposes
    var code:Int = 0
    var message:String = ""
    
    //Coords
    var lat:Float = 0.0
    var lon:Float = 0.0
    
    //Main
    var humidity:Int = 0
    var temp_max:Float = 0.0
    var temp_min:Float = 0.0
    var temp:Float = 0.0
    var pressure:Int = 0
    
    //Weather
    var conditions:String = ""
    var description:String = ""
    
    //Wind
    var wind_speed:Float = 0.0
    var wind_gust:Float = 0.0
    
}
