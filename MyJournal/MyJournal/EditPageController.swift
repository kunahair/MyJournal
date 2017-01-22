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



class EditPageController: UIViewController ,UIImagePickerControllerDelegate, MPMediaPickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate{
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var selectPhoto: UIButton!
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var selectMusic: UIButton!
    @IBOutlet weak var address: UITextView!
   
    @IBOutlet weak var musicFile: UITextField!
    
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var save: UIBarButtonItem!
    
    @IBOutlet weak var quote: UITextField!
    
    @IBOutlet weak var note: UITextView!
    
    @IBOutlet weak var isFavorite: UISwitch!
 
    
    let photoPicker = UIImagePickerController()
    
    let musicPicker = MPMediaPickerController()
    let locationManager = CLLocationManager()
    //let date = Date()
    var addressInfo = "Mark your location"
    var switchOn = false
    var photoURL: String!
    var photoPath:String!
    let today: String = Model.getInstance.getCurrentDate()
    
    /*  Change by Ryan, 21Jan, added weather result and mood picker ref here
        To Josh: Weather API shall be called in this VC and update the Label and save in the Model, which is 
        the func at the bottom :)
     */
    var mood: MoodEnum = MoodEnum.happy
    
    @IBOutlet weak var moodPickerView: UIPickerView!
    
    @IBOutlet weak var weatherResultLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoPicker.delegate = self
        musicPicker.delegate = self
        self.hideKeyboard()
        //sets the class as delegate for locationManager, specifies the location accuracy
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        currentDate.text = "\(today)"
        switchButton.isOn = false
        address.text = addressInfo
        
        // 21Jan Ryan:
        moodPickerView.dataSource = self
        moodPickerView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //handle users' selection in the photo library
    @IBAction func selectPhoto(_ sender: Any) {
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
        
        let selectedPhoto = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        //save selected photo data and get the url
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.photo.image = selectedPhoto
            }
            //get the saving time as the name of photo data
            let dateStr = Model.getInstance.getCurrentDateSec()
            self.photoURL = String(format: "%@.png", dateStr)
            let photoData = UIImagePNGRepresentation(selectedPhoto!)
            
            let photoPaths = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(self.photoURL)
            //write data
            do {
                try photoData?.write(to: photoPaths, options: .atomic)
            } catch {
                print(error)
            }
            
            let paths: NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
            let documentsDir: NSString = paths.object(at: 0) as! NSString
            
            self.photoPath  = documentsDir.appendingPathComponent(self.photoURL!)
            
            print("picture : "+"\(self.photoPath)")
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
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
   
   
    // Mood Picker and its funcs : Picker delegate and DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Model.getInstance.getMoodArray().count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Model.getInstance.getMoodArray()[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.mood = MoodEnum(mood: Model.getInstance.getMoodArray()[row])!
    }
    
    
    //save data to model
    // Notes-> Ryan 21Jan: waiting for weather & Location API calls when save to model
    // correct params waiting to be passed: weather, location, coordinates
    // Xing : add more features to improve user experience
    @IBAction func saveJournal(_ sender: Any) {
        
        
        if note.text == "" && musicFile.text == "" && quote.text == ""{
            let alert = UIAlertController (title: "No content has been added yet", message: "",     preferredStyle: UIAlertControllerStyle.actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (actionSheetController) -> Void in
            }))
            present(alert, animated: true)
        }else{
            //if user have chosen the picture for the journal
            self.activityIndicator.startAnimating()
            if self.photoPath == nil{
               
                Model.getInstance.journalManager.AddJournal(note: note.text, music: musicFile.text, quote: quote.text, photo:"", weather: "sunny", mood: self.mood.description, date: self.today, location: "RMIT",favorite: isFavorite.isOn, coordinates: [-37.6, 144.0])
                note.text = ""
                quote.text = ""
            }else{
                Model.getInstance.journalManager.AddJournal(note: note.text, music: musicFile.text, quote: quote.text, photo:self.photoPath, weather: "sunny", mood: self.mood.description, date: self.today, location: "RMIT",favorite: isFavorite.isOn, coordinates: [-37.6, 144.0])
                note.text = ""
                quote.text = ""
            }
            // 1 second later, this page will be closed
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1))
           {
                self.activityIndicator.stopAnimating()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
   
}
