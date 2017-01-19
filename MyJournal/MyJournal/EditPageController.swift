//
//  EditPageController.swift
//  MyJournal
//
//  Created by XINGZHAO on 13/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//


/*
    In this page, basic information as date and place will be automatically recorded based on your current location(to get location you will need to turn on the switch button). You can also choose from many emoji expressions to best describe the weather and your personal mood. Apart from logging your day by way of words and sentences, you can also choose sources from your own music library and photos to add to the journal
 */
import UIKit
import CoreLocation
import MediaPlayer



class EditPageController: UIViewController ,UIImagePickerControllerDelegate, MPMediaPickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate{

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var selectPhoto: UIButton!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var selectMusic: UIButton!
    @IBOutlet weak var musicFile: UITextField!
    @IBOutlet weak var address: UITextView!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var save: UIBarButtonItem!
    @IBOutlet weak var quote: UITextField!
    @IBOutlet weak var note: UITextView!
    
    @IBOutlet weak var isFavorite: UISwitch!
    
    let photoPicker = UIImagePickerController()
    
    let musicPicker = MPMediaPickerController()
    let locationManager = CLLocationManager()
    var addressInfo = "Mark your location"
    var switchOn = false
    
    
    // back stack ref
    var previousView = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoPicker.delegate = self
        musicPicker.delegate = self
        self.hideKeyboard()
        //sets the class as delegate for locationManager, specifies the location accuracy
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        var today = currentDay()
        currentDate.text = "\(today)"
        switchButton.isOn = false
        address.text = addressInfo
        
               
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //get current date in costom format
    func currentDay()->String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "DD/MM/YY"
        var dateStr = formatter.string(from: date)
        return dateStr
    }
    
    //handle users' selection in the photo library
    @IBAction func selectPhoto(_ sender: UIButton) {
        photoPicker.allowsEditing = false
        photoPicker.sourceType = .photoLibrary
        present(photoPicker, animated: true, completion: nil)
    }
    
    
    @IBAction func selectMusic(_ sender: Any) {
        musicPicker.allowsPickingMultipleItems = false
        musicPicker.showsCloudItems = false
        present(musicPicker, animated: true, completion: {})

    }
    
    
    //handle users' selection in the switch button
    @IBAction func getCurrentLocation(_ sender: Any) {
        if switchButton.isOn == true{
            self.switchOn = true
            //start receiving location updates from CoreLocation
            self.locationManager.startUpdatingLocation()
            print("switchButton + \(self.switchOn)")
        }else{
            address.text = addressInfo
        }
    }
    
    //Hide the keyboard when clicking anywhere except textview and textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.background.endEditing(true)
    }
    
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard))
            
        self.view.addGestureRecognizer(tap)
    }
        
    func dismissKeyboard()
    {
        self.view.endEditing(true)
    }
    

    //assign selected photo to the scene
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let selectedPhoto = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.photo.image = selectedPhoto
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        //if users are allowed to play music they chose
        //let musicPlayer = MPMusicPlayerController.applicationMusicPlayer() 
        //print("\(mediaItemCollection))")
        dismiss(animated: true, completion: nil)
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        dismiss(animated: true, completion: nil)
    }
    
  
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
                }
            }
        })
    }
    
    //print errlr while updating location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error"+error.localizedDescription)
    }
    
    func saveButtonState(){
        if (quote.text != "" || note.text != ""){
            save.isEnabled = true
            save.tintColor = UIColor.darkGray
        }else{
            save.isEnabled = false
            save.tintColor = (UIColor.darkGray)
        }
    }
    
    @IBAction func isFavorite(_ sender: Any) {
        
        if isFavorite.isOn == true{
            self.switchOn = true
            //start receiving location updates from CoreLocation
            self.locationManager.startUpdatingLocation()
            print("switchButton + \(self.switchOn)")
        }else{
            address.text = addressInfo
        }
    }
    
    
    @IBAction func saveJournal(_ sender: Any) {
        if isFavorite.isOn == true{
            Model.getInstance.journalManager.AddJournal(note: note.text, music: "", quote: quote.text!, photo:"winter", weather: "sunny", mood: "happy", date: "18/01/17", location: "RMIT",favorite: isFavorite.isOn, coordinates: [-37.6, 144.0])
            note.text = ""
            quote.text = ""
            
        }else{
            Model.getInstance.journalManager.AddJournal(note: note.text, music: "", quote: quote.text!, photo: "winter", weather: "sunny", mood: "happy", date: "18/01/17", location: "RMIT",favorite: isFavorite.isOn, coordinates: [-37.6, 144.0])
            note.text = ""
            quote.text = ""
        }
             
        self.navigationController?.popViewController(animated: true)
    }
       //elf.presentedViewController(nextViewController, animated:true, completion:nil)
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
