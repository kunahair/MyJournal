//
//  Weather.swift
//  MyJournal
//
//  Created by Yuanqing Jiang on 13/01/2017.
//  Copyright © 2017 LegDay. All rights reserved.
//

import Foundation

enum WeatherEnum: String {
    
    case rain, sunny, cloud, smog, windy
    
    
    // default init
    init() {
        self = .sunny
    }
    
    init?(weather: String) {
        switch weather {
        case "sunny": self = .sunny
        case "rain": self = .rain
        case "cloud": self = .cloud
        case "somg" : self = .smog
        case "windy" : self = .windy
        default: self = .sunny
        }
    }
    
    var description:String {
        get {
            switch self {
            case .sunny: return "sunny"
            case .rain: return "rain"
            case .cloud: return "cloud"
            case .smog: return "somg"
            case .windy: return "windy"
            }
        }
        
        set(weather) {
            switch weather {
            case "sunny": self = .sunny
            case "rain": self = .rain
            case "cloud": self = .cloud
            case "somg" : self = .smog
            case "windy" : self = .windy
            default: self = .sunny
            }
        }
    }
    
    var emoji: String {
        get {
            switch self {
            case .sunny: return "☀️"
            case .rain: return "☔️"
            case .cloud: return "☁️"
            case .smog: return "🌫"
            case .windy: return "💨"
            }
        }
    }
}
