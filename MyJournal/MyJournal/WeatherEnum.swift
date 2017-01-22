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
 **/
enum WeatherEnum: String {
    
    case rainy, sunny, cloudy, smog, windy
    
    
    // default init
    init() {
        self = .sunny
    }
    
    init?(weather: String) {
        switch weather {
        case "sunny": self = .sunny
        case "rainy": self = .rainy
        case "cloudy": self = .cloudy
        case "smog" : self = .smog
        case "windy" : self = .windy
        default: self = .sunny
        }
    }
    
    var description:String {
        get {
            switch self {
            case .sunny: return "sunny"
            case .rainy: return "rainy"
            case .cloudy: return "cloudy"
            case .smog: return "smog"
            case .windy: return "windy"
            }
        }
        
        set(weather) {
            switch weather {
            case "sunny": self = .sunny
            case "rainy": self = .rainy
            case "cloudy": self = .cloudy
            case "smog" : self = .smog
            case "windy" : self = .windy
            default: self = .sunny
            }
        }
    }
    
    var emoji: String {
        get {
            switch self {
            case .sunny: return "☀️"
            case .rainy: return "☔️"
            case .cloudy: return "☁️"
            case .smog: return "🌫"
            case .windy: return "💨"
            }
        }
    }
}
