//
//  PlacesViewController.swift
//  MyJournal
//
//  Created by Josh Gerlach on 17/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import UIKit
import MapKit

class PlacesViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Delegate MapView functions to self
        
        self.mapView.delegate = self
        
       setupPinAnnotations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Before each page load, check if the model has changed, if they have then resetup the pin annotations
        if mapView.annotations.count != Model.getInstance.journalManager.getJournalEntriesCount()
        {
            mapView.removeAnnotations(mapView.annotations)
            setupPinAnnotations()
        }
    }
    
    /**
     Setup Pin annotations on mapview, load from Model
    **/
    fileprivate func setupPinAnnotations(){
        var setupMapViewRegion:Bool = false
        
        //Loop through all entries, annotate with the date and the address
        for journalEntry in Model.getInstance.journalManager.getJournalEntriesArray()
        {
            let pinLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(journalEntry.coordinates[0], journalEntry.coordinates[1])
            let objectAnn = MKPointAnnotation()
            objectAnn.coordinate = pinLocation
            
            //Setup the Map view region, for the latest entry to be the center
            if !setupMapViewRegion {
                let viewRegion = MKCoordinateRegionMakeWithDistance(pinLocation, 500000.0, 500000.0)
                let adjustedRegion = mapView.regionThatFits(viewRegion)
                self.mapView.setRegion(adjustedRegion, animated: true)
                self.mapView.showsUserLocation = true
                setupMapViewRegion = true
            }
            
            
            //Setup annotation
            objectAnn.title = journalEntry.date
            objectAnn.subtitle = journalEntry.location
            
            //Place pin on map
            self.mapView.addAnnotation(objectAnn)
            
        }
    }
    
    //View loader for the Annotations on the map
    func mapView(_ mapView: MKMapView,
                          viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        //Check if annotation is of type MKUserLocation
        if annotation is MKUserLocation
        {
            return nil
        }
        
        //Check if we can reuse a view, if so, deque it and return as view
        let reuseID = "pin"
        var view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
            as? MKPinAnnotationView
        {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else
        {
            //Otherwise, we do our AnnotationView configuration here
            //Add a button to the right of the text in annotation view
            //This button will call the DetailViewController so the user can see details
            let button:UIButton = UIButton(type: .detailDisclosure)
            button.tag = Model.getInstance.journalManager.getJournalEntryAndIndexByDate(date: annotation.title!!)!.index
            button.addTarget(self, action: #selector(ratingButtonTapped), for: .touchDown)
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            view.canShowCallout = true
            view.isUserInteractionEnabled = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = button as UIButton
            
            return view
        }
        return view
    }
    
    // When Button is pressed, perform a Seque into the DetailViewController
    func ratingButtonTapped(sender: UIButton) {
        performSegue(withIdentifier: "DetailViewSegue", sender: sender)
    }
    
    //Prepare for Segue into the details page by setting the detail view journal to the selected index
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailView = segue.destination as! DetailViewController
        if segue.identifier == "DetailViewSegue" {
            let senderbutton = sender as! UIButton
            let journalIndex:Int = senderbutton.tag            
            detailView.journalDetail = Model.getInstance.journalManager.getJournalEntryByIndex(id: journalIndex)
            
        }
    }
  
  
}
