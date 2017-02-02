//
//  DeviceDate.swift
//  MyJournal
//
//  Created by Josh Gerlach on 15/01/2017.
//  Copyright © 2017 LegDay. All rights reserved.
//

import Foundation

/**
 Date Struct that holds a Date Object and processes calles based on that date
 **/
struct DeviceDate
{
    var date:Date = Date()
    
    init(date: Date)
    {
        self.date = date
    }
    
    //Get User Readable Date (day/month/year) from Date Object
    var readableDate:String
    {
        get{
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-YYYY"
            return formatter.string(from: date)

            }
    }
    
    //Get Unix (some call it EPOCH) time stamp from Date Object
    var unixDate:Double
    {
        get{
            return self.date.timeIntervalSince1970
        }
    }
}
