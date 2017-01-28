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



class EditPageController: UIViewController ,UIImagePickerControllerDelegate, MPMediaPickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, DataDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate{
    
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
 
    /*
        Ryan 26Jan; Record Audio Outlets and refs
     */
    @IBOutlet weak var audioPlayBtn: UIButton!
    @IBOutlet weak var audioRecordBtn: UIButton!
    
    let photoPicker = UIImagePickerController()
    let factor: Float = 273.15
    let musicPicker = MPMediaPickerController()
    let locationManager = CLLocationManager()
    var addressInfo = "Mark your location"
    var switchOn = false
    var photoURL: String!
    var photoPath:String!
    let today: String = Model.getInstance.getCurrentDate()
    var currentLocation:Location = Location()
    var currentWeather: String = "Auto display upon activating location"
    var currentTemp: String?
    var mood: MoodEnum = MoodEnum.happy
    var recordPathURL: URL!
    var videoWebURL: URL!
    
    @IBOutlet weak var moodPickerView: UIPickerView!
    
    @IBOutlet weak var weatherResultLabel: UILabel!
    
    @IBOutlet weak var videoTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoPicker.delegate = self
        musicPicker.delegate = self
        self.hideKeyboard()
        //sets the class as delegate for locationManager, specifies the location accuracy
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        weatherResultLabel.text = currentWeather
        weatherResultLabel.textColor = UIColor.gray
         weatherResultLabel.font = UIFont.systemFont(ofSize: 14)
        currentDate.text = "\(today)"
        switchButton.isOn = false
        address.text = addressInfo
        moodPickerView.dataSource = self
        moodPickerView.delegate = self
       
        // Ryan 26Jan: set up the recorder when loading the page
        Model.getInstance.fileOpManager.setupRecorder(avDelegate: self, dataDelegate: self)
        
        //Set a quote and note for testing
        //NOTE: MUST BE DELETED #######
        note.text = "This is a test note"
        quote.text = "This is a test quote"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let location = try? Model.getInstance.getLocation()        
        if location == nil{
            self.weatherResultLabel.text = currentWeather
        }else{
            self.currentLocation = location!
            let weatherData = ParseWeatherData()
            weatherData.getWeatherData(lat: (location?.lat)!, lon: (location?.lon)!)
            weatherData.delegate = self
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func parseResult(dataList: Array<Weather>) {
        let weather = Weather()
        for weather in dataList{
            self.currentWeather = weather.description+"   "+String(weather.temp-factor)+"°C"
            
        }
        
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
    
    
    
    
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        dismiss(animated: true, completion: nil)
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        dismiss(animated: true, completion: nil)
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
    
    //Action placeholder if favourite switch need to do Model work
    @IBAction func isFavorite(_ sender: Any) {
        
    }
   
   
    
    
    
    //save data to model
    // Notes-> Ryan 21Jan: waiting for weather & Location API calls when save to model
    // correct params waiting to be passed: weather, location, coordinates
    // Xing : add more features to improve user experience
    // Josh: Increased code maintainability by having only one Journal entry write to the Model
    @IBAction func saveJournal(_ sender: Any) {
        //Show alert if user has not entered information into note (otherwise why have a journal right?)
        if note.text!.isEmpty  {
            let alert = UIAlertController (title: "No content has been added to notes", message: "",     preferredStyle: UIAlertControllerStyle.actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (actionSheetController) -> Void in
            }))
            present(alert, animated: true)
        }else{
            var photoPath:String = "defaultphoto"
            //Check if photo path has been set, assign if nessessary
            if self.photoPath != nil
            {
                photoPath = self.photoPath
            }
             //if user have chosen the picture for the journal
            //Save Journal entry to memory model
            Model.getInstance.journalManager.AddJournal(note: note.text, music: musicFile.text, quote: quote.text, photo:photoPath, weather: self.weatherResultLabel.text!, mood: self.mood.description, date: self.today, location: address.text,favorite: isFavorite.isOn, coordinates: [Double(currentLocation.lat), Double(currentLocation.lon)], recordURL: recordPathURL, videoURL: self.videoWebURL)
            note.text = ""
            quote.text = ""
           //start saving animation
            self.activityIndicator.startAnimating()
            
            // 1 second later, this page will be closed
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1))
            {
                self.activityIndicator.stopAnimating()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    /*
        Ryan - 26Jan; audio button actions
     */

    @IBAction func audioRecordAction(_ sender: UIButton) {
        if sender.titleLabel?.text == "Record" { // if btn is record, start recording
            sender.setTitle("Stop", for: UIControlState()) // change btn to Stop
            audioPlayBtn.isEnabled = false // disable play btn
            Model.getInstance.fileOpManager.startRecording()
        }
        else { // otherwise, stop recording
            sender.setTitle("Record", for: UIControlState())
            Model.getInstance.fileOpManager.stopRecording()
        }
    }
    
    
    @IBAction func audioPlayAction(_ sender: UIButton) {
        if sender.titleLabel?.text == "Play" {
            if self.recordPathURL == nil { // when there's no recording
                print("NO recording Found")
                return
            }
            audioRecordBtn.isEnabled = false
            sender.setTitle("Stop", for: .normal)
            // then prepare and play the audio player
            if self.recordPathURL == nil {
                print("NIL Record Path when playing")
                return
            }
            else {
                print("Trying to play: \(self.recordPathURL!)")
                Model.getInstance.fileOpManager.startPlaying(audioURL: self.recordPathURL)
            }
        }
        else {
            sender.setTitle("Play", for: .normal)
            audioRecordBtn.isEnabled = true
            Model.getInstance.fileOpManager.stopPlaying()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WebGetSegue" {
            let destination = segue.destination as! WebViewController
            destination.dataDelegate = self
        }
    }
    
    // record delegate funcs
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        audioPlayBtn.isEnabled = true
        audioRecordBtn.setTitle("Record", for: .normal)
    }
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error when recording: \(error!.localizedDescription)")
    }
    // player delegate funcs
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        audioRecordBtn.isEnabled = true
        audioPlayBtn.setTitle("Play", for: .normal)
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Error when playing: \(error!.localizedDescription)")
    }
    
    // when recording stops, receive filepath as delegate
    func receiveFilePath(filePathURL: URL) {
        self.recordPathURL = filePathURL
        print("Record Audio Path Received: \(self.recordPathURL)")
    }
    
    // receive and set video url
    func receiveVideoURL(webURL: URL) {
        self.videoWebURL = webURL
        videoTextfield.text = webURL.absoluteString
        print("Video URL Received: \(self.videoWebURL)")
    }
}
