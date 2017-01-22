//
//  OpenWeather.swift
//  MyJournal
//
//  Created by Josh Gerlach on 12/01/2017.
//  Copyright © 2017 LegDay. All rights reserved.
//

import Foundation

/**
 OpenWeatherMap API facade to collect weather information and return a Weather Object
 **/
class OpenWeatherMap{
    
    //OpenWeatherMap API key
    fileprivate let apiKey: String = "23ab6085c0b41e09efcf10995f55da15"
    
    
    /**
     User facing function that takes a lat and long and returns a Weather Object
    **/
    func getCurrentWeather(lat: Float, lon: Float)->Weather
    {
        //Get Weather String JSON from API
        let apiWeather = getWeatherFromAPI(lat: lat, lon: lon)
        
        //Convert Weather from API into JSON Object
        let weatherJSON = JSON.init(parseJSON: apiWeather)
        
        
        //Return Weather Object
        return loadWeatherData(weatherJSON: weatherJSON)
    }
    
    /**
     Private function that actually gathers the Weather info from the OpenWeatherMap API
     
     NB:For now returns static, will need to make Network call when completed
    **/
    private func getWeatherFromAPI(lat: Float, lon: Float)->String
    {
        
        return "{\"coord\":{\"lon\":138.93,\"lat\":34.97},\"weather\":[{\"id\":801,\"main\":\"Clouds\",\"description\":\"few clouds\",\"icon\":\"02d\"}],\"base\":\"stations\",\"main\":{\"temp\":283.83,\"pressure\":1005,\"humidity\":100,\"temp_min\":283.15,\"temp_max\":284.15},\"visibility\":10000,\"wind\":{\"speed\":5.7,\"deg\":240,\"gust\":11.3},\"clouds\":{\"all\":20},\"dt\":1484190000,\"sys\":{\"type\":1,\"id\":7616,\"message\":0.0097,\"country\":\"JP\",\"sunrise\":1484171543,\"sunset\":1484207580},\"id\":1851632,\"name\":\"Shuzenji\",\"cod\":200}"
    }
    
    /**
     Private function to load JSON data into Weather Object
     **/
    private func loadWeatherData(weatherJSON: JSON)->Weather
    {
        var weather = Weather()
        weather.lat = weatherJSON["coord"]["lat"].floatValue
        weather.lon = weatherJSON["coord"]["lon"].floatValue
        
        weather.humidity = weatherJSON["main"]["humidity"].intValue
        weather.temp_max = weatherJSON["main"]["temp_max"].floatValue
        weather.temp_min = weatherJSON["main"]["temp_max"].floatValue
        weather.temp = weatherJSON["main"]["temp"].floatValue
        weather.pressure = weatherJSON["main"]["pressure"].intValue
        
        weather.conditions = weatherJSON["weather"][0]["main"].stringValue
        weather.description = weatherJSON["weather"][0]["description"].stringValue
        
        weather.wind_speed = weatherJSON["wind"]["speed"].floatValue
        weather.wind_gust = weatherJSON["wind"]["gust"].floatValue
        
        return weather
    }
    
}
    
