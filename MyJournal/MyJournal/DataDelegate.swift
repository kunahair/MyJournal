//
//  DataDelegate.swift
//  MyJournal
//
//  Created by XING ZHAO on 25/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import Foundation


protocol DataDelegate {
    func parseResult(dataList: Array<Weather>) //to receive weather data
    
    func receiveVideoURL(webURL: URL) // to receive youtube video url
    
    func receiveFileName(fileName: String) // to receive audio file name
    
    /**
     Protocol to delegate a callback to Update Weather info either in the UI or some Model, retrieved from a Weather information source
     This way the functionality can be expanded if needed, where weather can be collected from anywhere and acted on
     **/
     
    func updateWeather(weather: Weather)
    

}
