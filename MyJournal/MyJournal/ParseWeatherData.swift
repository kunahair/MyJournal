//
//  ParseWeatherData.swift
//  MyJournal
//
//  Created by XING ZHAO on 25/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import Foundation
import UIKit

class ParseWeatherData: UIViewController{
    
    fileprivate let apiKey: String = "23ab6085c0b41e09efcf10995f55da15"
    private let openWeatherMapURL = "http://api.openweathermap.org/data/2.5/weather"
    var delegate: DataDelegate? = nil
    var weatherJSON: AnyObject?
    
    
  
    //receive the data, response details and error
    func getWeatherData(lat: Float, lon: Float)
    {
        // setup the session
        let session = URLSession.shared
        let urlRequest = URL(string:"\(openWeatherMapURL)?lat=\(lat)&lon=\(lon)&APPID=\(apiKey)")!
        // make the POST call and handle it in a completion handler
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Error :  + \(error)")
                return
            }
            DispatchQueue.main.async {
                self.loadWeatherData(weatherData: data!)
            }
            //print json data
            let dataStr = String(data: data!, encoding: .utf8)!
            print(dataStr)
        }
        dataTask.resume()    
    }
    
    /**
     Private function to load JSON data into Weather Object
     **/

    private func loadWeatherData(weatherData: Data)
    {
        do {
            self.weatherJSON = try JSONSerialization.jsonObject(with: weatherData, options: []) as! NSDictionary
            
        } catch {
            print("Error :  + \(error)")
        }
        var weatherDataList: [Weather] = []
        var weather = Weather()
        if let coord = weatherJSON!["coord"] as? NSDictionary {
            if let lat = coord["lat"] as? Float {
                weather.lat = lat
            }
            if let lon = coord["lon"] as? Float {
                weather.lat = lon
            }
        }
        if let main = weatherJSON!["main"] as? NSDictionary {
            if let humidity = main["humidity"] as? Int {
                weather.humidity = humidity
            }
            if let temp_max = main["temp_max"] as? Float {
                weather.temp_max = temp_max
            }
            if let temp_min = main["temp_min"] as? Float {
                weather.temp_min = temp_min
            }
            if let temp = main["temp"] as? Float {
                weather.temp = temp
            }
            if let pressure = main["pressure"] as? Int {
                weather.pressure = pressure
            }
        }
        if let weatherArray = weatherJSON!["weather"] as? NSArray {
            let weatherDir = weatherArray[0] as? NSDictionary
            if let conditions = weatherDir?["main"] as? String {
                weather.conditions = conditions
            }
            if let description = weatherDir?["description"] as? String {
                weather.description = description                
                
            }
        }
        if let wind = weatherJSON!["wind"] as? NSDictionary {
            if let speed = wind["speed"] as? Float {
                weather.wind_speed = speed
            }
            if let gust = wind["gust"] as? Float {
                weather.wind_gust = gust
            }
        }
        weatherDataList.append(weather)
        if delegate != nil {
            delegate?.parseResult(dataList: weatherDataList)
            dismiss(animated: true, completion: nil)
        }
    }
    
}
