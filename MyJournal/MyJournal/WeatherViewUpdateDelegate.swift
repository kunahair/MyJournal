//
//  ViewUpdateFromAPI.swift
//  MyJournal
//
//  Created by Josh Gerlach on 31/1/17.
//  Copyright © 2017 Xing. All rights reserved.
//

import Foundation

/**
 Protocol to delegate a callback to Update Weather info either in the UI or some Model, retrieved from a Weather information source
 This way the functionality can be expanded if needed, where weather can be collected from anywhere and acted on
 **/
protocol WeatherViewUpdateDelegate {
    
    func updateWeather(weather: Weather)
}
