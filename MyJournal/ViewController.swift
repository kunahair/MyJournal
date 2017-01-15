//
//  ViewController.swift
//  MyJournal
//
//  Created by Josh Gerlach on 13/01/2017.
//  Copyright © 2017 LegDay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Instanciate a new Model
        let model = Model()
        
        //Get Device Location
        var location:Location? = try? model.getLocation()
        
        //Handle location error if needed
        if location == nil {
            //Handle if location is nil, that is, threw an error
            print("Location is nil")
        }else{
            location = model.getReadableAddress(lat: location!.lat, lon: location!.lon)
            
            print(location!)
        }
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

