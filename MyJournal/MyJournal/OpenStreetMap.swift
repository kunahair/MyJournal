//
//  OpenStreetMap.swift
//  MyJournal
//
//  Created by Josh Gerlach on 14/01/2017.
//  Copyright © 2017 LegDay. All rights reserved.
//

import Foundation

class OpenStreetMap {
    
    //Return readable address
    func getReadableAddress(lat: Float, lon: Float)->String
    {
       
        let address:String = getAddressFromAPI(lat: lat, lon: lon)
        
        let addressJSON = JSON(parseJSON: address)
        
        return addressJSON["display_name"].stringValue
    }
    
    /**
     Private function to get User Readable Address from OpenStreetMap API
     
     NB: Returns hard coded JSON String for now, on completion will have to use Network Call
    **/
    private func getAddressFromAPI(lat: Float, lon: Float)->String
    {
        return "{\"place_id\":\"69013596\",\"licence\":\"Data © OpenStreetMap contributors, ODbL 1.0. http://www.openstreetmap.org/copyright\",\"osm_type\":\"way\",\"osm_id\":\"26564387\",\"lat\":\"-37.80856345\",\"lon\":\"144.963932957283\",\"display_name\":\"Building 8, Swanston Street, Chinatown, Melbourne (3000), Melbourne, City of Melbourne, Greater Melbourne, Victoria, 3000, Australia\",\"boundingbox\":[\"-37.8089882\",\"-37.8081266\",\"144.9635111\",\"144.9641815\"]}"
    }
}
