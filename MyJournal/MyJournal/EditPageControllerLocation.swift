//
//  EditPageControllerLocation.swift
//  MyJournal
//
//  Created by Josh Gerlach on 28/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import Foundation
import MapKit

/**
 Extension to handle the Location Manager callbacks for EditPageController
 **/
extension EditPageController {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //process the location array (placeMarks)
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: { placeMarks, error in
            guard let address = placeMarks?[0].addressDictionary else {
                return
            }
            //log the message to the console when there is an error, .
            if error != nil{
                print("Error : "+(error?.localizedDescription)!)
            }
            if self.switchOn == true{
                // get formatted address
                if let formattedAddress = address["FormattedAddressLines"] as? [String] {
                    self.locationManager.stopUpdatingLocation()
                    self.address.text = formattedAddress.joined(separator: ", ")
                    //Update weather based on location
                    self.weatherResultLabel.font = UIFont.systemFont(ofSize: 17)
                    self.weatherResultLabel.textColor = UIColor.black
                    self.weatherResultLabel.text = self.currentWeather
                    
                }
            }
        })
    }
    
    //print errlr while updating location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error"+error.localizedDescription)
    }
}
