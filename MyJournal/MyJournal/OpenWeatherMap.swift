//
//  OpenWeatherMap.swift
//  MyJournal
//
//  Created by Josh Gerlach on 31/1/17.
//  Copyright © 2017 Xing. All rights reserved.
//

import Foundation

/**
 Stuct got get Weather from OpenWeatherMap API and update the selected delegate with Weather struct
 **/
struct OpenWeatherMap {
    
    //Delegate callback that updates a View
    var delegate:DataDelegate?
    
    /**
     Function that is called to get the Weather information from the OpenWeatherMap API
     Takes a lat and lon argument, makes call to API with given params and on success updates the delegate view
     **/
    func getWeatherFromAPI(lat: Float, lon: Float)
    {
        var weather:Weather = Weather()
        
        //Get reference to URL Shared Session
        let session = URLSession.shared
        
        //Construct the string that will become the API call
        let apiKey: String = "appid=ccf326320df97a1165a2f95e1c638612"
        let openWeatherMapURL = "http://api.openweathermap.org/data/2.5/weather?"
        let units:String = "units=metric"
        let locationString:String = "lat=" + String(lat) + "&lon=" + String(lon)
        //Merge all the arguments into string for use
        let getWeather:String = openWeatherMapURL + locationString + "&" + units + "&" + apiKey
        
        //Start the URL Session to get Weather info
        if let url = URL(string: getWeather){
            let request = URLRequest(url: url)
            
            //Start the GET task to retrieve Weather info
            let _ = session.dataTask(with: request, completionHandler:
                {
                    data, response, downloadError in
                    
                    if let error = downloadError
                    {
                        //If there was an error, print it
                        print("\(data) \n data")
                        print("\(response) \n response")
                        print("\(error) \n error")
                        //Update the delegate so user knows what is happening
                        if self.delegate != nil
                        {
                            weather.message = "An Error Occured"
                            self.delegate!.updateWeather(weather: weather)
                        }
                    }
                    else
                    {
                        //Otherwise convert the response (data) into a String for JSON processing
                        let responseString:String = String(data: data!, encoding: String.Encoding.utf8)!
                        //Convert response String into JSON
                        let parsedJSON = JSON.init(parseJSON: responseString)
                        
                        //Update the delegate view on the main thread to avoid collisions
                        DispatchQueue.main.async
                            {
                                if self.delegate != nil
                                {
                                    //If weather info was retrieved, then post back to delagate caller
                                    weather = self.loadWeatherData(weatherJSON: parsedJSON)
                                    if weather.code == 200 { //200 means success in HTTP world
                                        self.delegate!.updateWeather(weather: weather)
                                        //print json data
                                        let dataStr = String(data: data!, encoding: .utf8)!
                                        print(dataStr)
                                    }
                                    else
                                    {
                                        //Otherwise, send back an error
                                        weather.message = "An Error Occured"
                                        self.delegate!.updateWeather(weather: weather)
                                    }
                                    
                                }
                        }
                        
                    }
            }
                
                ).resume()
            
        }
        
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
        
        weather.code = weatherJSON["cod"].intValue
        
        return weather
    }
}
