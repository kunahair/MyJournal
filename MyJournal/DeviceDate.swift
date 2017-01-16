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
//    {
//        get{
//            return self.date
//        }
//        set(date){
//            self.date = date
//        }
//    }
    
    init(date: Date)
    {
        self.date = date
    }
    
    //Get User Readable Date (day/month/year) from Date Object
    var readableDate:String
    {
        get{
//            let calendar:Calendar = Calendar.current
            
            let formatter = DateFormatter()
            formatter.dateFormat = "DD/MM/YY"
            return formatter.string(from: date)

            
//            return String(calendar.component(.day, from: self.date)) + "/" +
//                String(calendar.component(.month, from: self.date)) + "/" +
//                String(calendar.component(.year, from: self.date))
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
