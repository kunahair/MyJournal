//
//  ViewUpdateFromAPI.swift
//  MyJournal
//
//  Created by Josh Gerlach on 31/1/17.
//  Copyright © 2017 Xing. All rights reserved.
//

import Foundation

/**
 Protocol to delegate a callback to Update the UI from API
 This way the functionality can be expanded if needed, hence ViewUpdateFromAPI, not just weather
 **/
protocol ViewUpdateFromAPIDelegate {
    
    func updateWeather(weather: Weather)
}
