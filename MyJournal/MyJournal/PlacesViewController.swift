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

        // Do any additional setup after loading the view.
        
        self.mapView.delegate = self
        
        var i:Double = 0.0
        
        for journalEntry in Model.getInstance.journalManager.getJournalEntriesArray()
        {
            let pinLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(journalEntry.coordinates[0], journalEntry.coordinates[1] + i)
            let objectAnn = MKPointAnnotation()
            objectAnn.coordinate = pinLocation
           // let span = MKCoordinateSpanMake(0.075, 0.075)
            //let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -37.808515, longitude: 144.9695), span: span)
            
          //  let viewRegion = MKCoordinateRegionMakeWithDistance(pinLocation, 500, 500);
           // MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
           // [self.mapView setRegion:adjustedRegion animated:YES];
            
            
            let viewRegion = MKCoordinateRegionMakeWithDistance(pinLocation, 500, 500)
            let adjustedRegion = mapView.regionThatFits(viewRegion)
            self.mapView.setRegion(adjustedRegion, animated: true)
            self.mapView.showsUserLocation = true
            //mapView.setRegion(region, animated: true)
            objectAnn.title = journalEntry.date
            objectAnn.subtitle = journalEntry.location
            self.mapView.addAnnotation(objectAnn)
            
            i += 0.5
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
//            button.tag = Model.getInstance.getJournalIndexByDate(date: annotation.title!!)
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
        //print(String(sender.tag))
     
        performSegue(withIdentifier: "DetailViewSegue", sender: sender)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailView = segue.destination as! DetailViewController
        if segue.identifier == "DetailViewSegue" {
            let senderbutton = sender as! UIButton
            let journalIndex:Int = senderbutton.tag
            
            print(journalIndex)
            
//            detailView.journalObj = Model.getInstance.getJournalEntriesArray()[journalIndex]
            detailView.journalDetail = Model.getInstance.journalManager.getJournalEntryByIndex(id: journalIndex)
            
        }
    }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
