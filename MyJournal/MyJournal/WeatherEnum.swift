//
//  Weather.swift
//  MyJournal
//
//  Created by Yuanqing Jiang on 13/01/2017.
//  Copyright © 2017 LegDay. All rights reserved.
//

import Foundation

/**
 Enum that matches weather with an icon
 Weather cases taken from OpenWeatherMap documentation: http://openweathermap.org/weather-conditions
 Plus some of our own nouns for describing weather.
 **/
enum WeatherEnum: String {
    
    case rainy, sunny, cloudy, snowy, windy
    
    
    // default init
    init() {
        self = .rainy
    }
    
    init?(weather: String) {
        let weatherLowercase:String = weather.lowercased()
        switch weatherLowercase {
            case "sunny": self = .sunny
            case "rainy": self = .rainy
            case "rain": self = .rainy
            case "drizzle": self = .rainy
            case "thunderstorm": self = .rainy
            case "cloudy": self = .cloudy
            case "clouds": self = .cloudy
            case "snowy" : self = .snowy
            case "snow" : self = .snowy
            case "atmosphere" : self = .snowy
            case "clear" : self = .sunny
            case "extreme" : self = .sunny
            case "additional" : self = .sunny
            case "windy" : self = .windy
            default: self = .rainy
        }
    }
    
    var description:String {
        get {
            switch self {
                case .sunny: return "sunny"
                case .rainy: return "rainy"
                case .cloudy: return "cloudy"
                case .snowy: return "snowy"
                case .windy: return "windy"
            }
        }
        
        set(weather) {
            let weatherLowercase:String = weather.lowercased()
            switch weatherLowercase {
                case "sunny": self = .sunny
                case "rainy": self = .rainy
                case "rain": self = .rainy
                case "drizzle": self = .rainy
                case "thunderstorm": self = .rainy
                case "cloudy": self = .cloudy
                case "clouds": self = .cloudy
                case "snowy" : self = .snowy
                case "snow" : self = .snowy
                case "atmosphere" : self = .snowy
                case "clear" : self = .sunny
                case "extreme" : self = .sunny
                case "additional" : self = .sunny
                case "windy" : self = .windy
                default: self = .rainy
            }
        }
    }
    
    var emoji: String {
        get {
            switch self {
            case .sunny: return "☀️"
            case .rainy: return "☔️"
            case .cloudy: return "☁️"
            case .snowy: return "🌫"
            case .windy: return "💨"
            }
        }
    }
}
