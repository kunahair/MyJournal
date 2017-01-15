//
//  EditPageController.swift
//  MyJournal
//
//  Created by XINGZHAO on 13/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//


/*
 In this page, basic information as date and place will be automatically recorded based on your current location(to get location you
 will need to turn on the switch button). You can also choose from many emoji expressions to best describe the weather and your personal
 mood. Apart from logging your day by way of words and sentences, you can also choose sources from your own music library and photos to
 add to the journal
 */
import UIKit
import MediaPlayer

class EditPageController: UIViewController ,UIImagePickerControllerDelegate, MPMediaPickerControllerDelegate,UINavigationControllerDelegate{
    
    let model:Model = Model()
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var selectPhoto: UIButton!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var selectMusic: UIButton!
    @IBOutlet weak var musicFile: UITextField!
    @IBOutlet weak var address: UITextView!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    
    
    let photoPicker = UIImagePickerController()
    let musicPicker = MPMediaPickerController()
//    let locationManager = CLLocationManager()
    var addressInfo = "Mark your location"
    var locationSwitchOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoPicker.delegate = self
        musicPicker.delegate = self
        self.hideKeyboard()
        
        let date:String = model.getUserReadableDate(date: Date())
        currentDate.text = date
        
        switchButton.isOn = self.locationSwitchOn
        address.text = addressInfo
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    //handle users' selection of the location switch button
    @IBAction func getCurrentLocation(_ sender: Any) {
        if switchButton.isOn == true{
            self.locationSwitchOn = true
            
            //Get Device Location
            var location:Location? = try? model.getLocation()
            
            //Handle location error if needed
            if location == nil {
                //Handle if location is nil, that is, threw an error
                address.text = "An error occured getting Location"
            }else{
                location = model.getReadableAddress(lat: location!.lat, lon: location!.lon)
                
                addressInfo = location!.address
                
                address.text =  addressInfo
                
                //Update Weather Label, as OpenWeatherMap needs location
                weatherLabel.text = model.getWeather(lat: location!.lat, lon: location!.lon).description
            }
            
        }else{
            self.locationSwitchOn = false
            addressInfo = "Mark your location"
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
