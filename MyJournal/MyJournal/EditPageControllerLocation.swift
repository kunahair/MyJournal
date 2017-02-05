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
                    //Set text to show that the Weather info is loading
                    self.weatherResultLabel.textColor = UIColor.gray
                    
                    
                    //Check if device is connected to internet before doing API call
                    if ReachabilityStatus.isConnected()
                    {
                        //Get Weather info from API, so errors if needed
                        do {
                            //Get Location from Model conveinience function
                            let location:Location? = try Model.getInstance.getLocation()
                            
                            self.currentLocation = location!
                            //If location is recieved with no errors, then get weather from API
                            var openWeatherMap:OpenWeatherMap = OpenWeatherMap()
                            openWeatherMap.delegate = self
                            openWeatherMap.getWeatherFromAPI(lat: location!.lat, lon: location!.lon)
                        }catch {
                            //If there was an error, tell user
                            self.weatherResultLabel.text = "An Error Occured"
                        }
                    }else {
                        //Tell user that there is no internet connection
                        self.weatherResultLabel.text = "No Internet Connection"
                    }
                    
                }
            }
        })
    }
    
    //print errlr while updating location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error"+error.localizedDescription)
    }
}
