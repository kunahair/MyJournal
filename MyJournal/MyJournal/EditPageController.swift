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



class EditPageController: UIViewController ,UIImagePickerControllerDelegate, MPMediaPickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, DataDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate,UITextViewDelegate{
    
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
    @IBOutlet weak var audioPlayBtn: UIButton!
    @IBOutlet weak var audioRecordBtn: UIButton!
    
    let photoPicker = UIImagePickerController()
    let musicPicker = MPMediaPickerController()
    let locationManager = CLLocationManager()
    let defaultPhoto = "defaultphoto"
    /**
     Tracker information to hold state data of user input, mostly for initialsation
    **/
    let notePlaceholderText: String = "What's new about today?"
    var addressInfo = "Mark your location"
    var today: String = Model.getInstance.getCurrentDate()
    var switchOn = false
    var photoURL: String!
    var photoPath:String!
    var currentLocation:Location = Location()
    var currentWeather: String = "Auto display upon activating location"
    var currentTemp: String?
    var mood: MoodEnum = MoodEnum.happy
    var recordFileName: String!
    var videoWebURL: URL!
    var weatherDes = WeatherEnum()
    var journalDetail:Journal?
    var musicFileInfo: String = ""
    var locationStatus: Bool = false
    //var id: String?
    @IBOutlet weak var moodPickerView: UIPickerView!
    
    @IBOutlet weak var weatherResultLabel: UILabel!
    
    @IBOutlet weak var videoTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Hide the keyboard when the view is first loaded
        self.hideKeyboard()
        //Assign all nessary delegates
        photoPicker.delegate = self
        musicPicker.delegate = self
        note.delegate = self
        
        //sets the class as delegate for locationManager, specifies the location accuracy and user request
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()

        //Set mood picker delgate and datasource
        moodPickerView.dataSource = self
        moodPickerView.delegate = self
        
        //Setup the Audio Recorder
        Model.getInstance.fileOpManager.setupRecorder(avDelegate: self, dataDelegate: self)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        //If we are in edit mode, fill in information
        if journalDetail != nil {
            self.note.text = journalDetail!.note
            self.quote.text = journalDetail!.quote
            self.isFavorite.isOn = journalDetail!.favorite
            self.today = journalDetail!.date
            self.currentDate.text = today
            self.photoPath = Model.getInstance.getFilePathFromDocumentsDirectory(filename: journalDetail!.photo)
            
            photoURL = journalDetail!.photo //"defaultphoto"
            musicFileInfo = journalDetail!.music
            videoWebURL = journalDetail!.videoURL
            recordFileName = journalDetail!.recordName
            let locationInfo = journalDetail?.location
            let photoName = journalDetail?.photo
            let weatherInfo = journalDetail?.weather
            if weatherInfo == "No Internet Connection"{
                currentWeather = "sunny"
                weatherResultLabel.text = weatherInfo
            }else{
                currentWeather = weatherInfo!
                weatherResultLabel.text = weatherInfo
            }
            //if users didnt add location info to the journal, switch button of
            //location is off
            if locationInfo == "Mark your location"{
                locationStatus = false
            }else{
                locationStatus = true
                addressInfo = (journalDetail?.location)!
                self.currentLocation.lat = Float(journalDetail!.coordinates[0])
                self.currentLocation.lon = Float(journalDetail!.coordinates[1])
            }
            if photoName == "defaultphoto"{
                photo.image = UIImage(named: "defaultphoto")
            }else{
                photo.image = UIImage(contentsOfFile: self.photoPath)
            }
            
            //Get the array index value for the mood
            let moodInt:Int = Model.getInstance.getMoodByName(name: journalDetail!.mood)
            //If the index is valid, then set the mood picker
            if moodInt != -1 {
                moodPickerView.selectRow(moodInt, inComponent: 0, animated: true)
            }
        }else {
            //If we are in create mode, setup the default values
            if(self.note.text == notePlaceholderText || self.note.text == "") {
                self.note.text = notePlaceholderText
                self.note.textColor = UIColor.gray
            } else {
                self.note.textColor = UIColor.black
            }
            
            currentDate.text = "\(today)"
            
            address.text = addressInfo
            
            //Set defaults for switches
            isFavorite.isOn = true
            switchButton.isOn = false
            
            //Set default weather Label text
            weatherResultLabel.text = currentWeather
            weatherResultLabel.textColor = UIColor.gray
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //if users start to type, placeholderText dispears
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.note.text == notePlaceholderText{
            self.note.text = ""
            self.note.textColor = UIColor.black
        }
        self.note.becomeFirstResponder()
    }
    //if users finish editing without entering anything, placeholderText will reappear
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.note.text == ""{
            self.note.text = notePlaceholderText
            self.note.textColor = UIColor.gray
        }
        self.note.resignFirstResponder()

    }
   
   //Parse Weather results to ensure it is valid Weather Enum Data
    func parseResult(dataList: Array<Weather>) {
        for weather in dataList{
             self.currentWeather = weather.description
            //check the keyword from weather data
            if(weather.description.contains("clouds")){
                self.weatherDes = WeatherEnum(weather: "cloudy")!
            }else if (weather.description.contains("clear")){
                self.weatherDes = WeatherEnum(weather: "sunny")!
            }else if (weather.description.contains("clear")){
                self.weatherDes = WeatherEnum(weather: "sunny")!
            }else if (weather.description.contains("rain")||weather.description.contains("drizzle")||weather.description.contains("thunderstorm")){
                self.weatherDes = WeatherEnum(weather: "rainy")!
            }else if (weather.description.contains("snow")){
                self.weatherDes = WeatherEnum(weather: "snowy")!
            }
        }
        
       
    }
    
    //handle users' selection in the photo library
    @IBAction func selectPhoto(_ sender: Any) {
        photoPicker.allowsEditing = false
        photoPicker.sourceType = .photoLibrary
        present(photoPicker, animated: true, completion: nil)
    }
  
    //direct user to the music library
    @IBAction func selectMusic(_ sender: Any) {
        musicPicker.allowsPickingMultipleItems = false
        musicPicker.showsCloudItems = false
        present(musicPicker, animated: true, completion: {})
    }
    
    //handle users' selection in the switch button

    @IBAction func getCurrentLocation(_ sender: Any) {
        if switchButton.isOn == true{
            if ReachabilityStatus.isConnected() == false{
                address.text = "No Internet Connection"
                weatherResultLabel.text = "No Internet Connection"
            }else{
                self.weatherResultLabel.text = "Loading..."
                self.switchOn = true
            //start receiving location updates from CoreLocation
                self.locationManager.startUpdatingLocation()}
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
    

    
    /**
     Save Journal Entry
     add an saving animation to improve user experience
     Increased code maintainability by having only one Journal entry write to the Model
     Do a check that the save was successful both in the database and the model, if not, show user error but do not delete their work.
    **/
    @IBAction func saveJournal(_ sender: Any) {
        //placeHolderText is not the content typed by users, so cannot be saved as note
        if(note.text == notePlaceholderText){
            note.text = ""
            self.note.textColor = UIColor.black
        }
        //Show alert if user has not entered information into note (otherwise why have a journal right?)
        if note.text!.isEmpty  {
            showAlert(message: "No content has been added to the notes section")
        }else{
            var photoPath:String = "defaultphoto"
            //Check if photo path has been set, assign if nessessary
            if self.photoPath != nil
            {
                photoPath = self.photoPath
            }
            
            //Save Journal Entry to database and Model
            //If the save was successful, then go back to initial view (the calling view) with some fancy animation
            //Xing: change the value that pass to weather
            //Xing: if the journal exists, then update to memory model and database, otherwise add a new journal
            if(self.journalDetail == nil){
                if Model.getInstance.journalManager.addJournal(note: note.text, music: musicFile.text, quote: quote.text, photo:photoPath, weather: self.weatherDes.description, mood: self.mood.description, date: self.today, location: address.text, favorite: isFavorite.isOn, coordinates: [Double(currentLocation.lat), Double(currentLocation.lon)], recordName: recordFileName, videoURL: self.videoWebURL){
                }else{
                    //tell the user that the save was not successful, without deleting their work
                    showAlert(message: "Failed to save Journal Entry, please try again")
                }
            }else{
                if  Model.getInstance.journalManager.updateJournalEntry(id: journalDetail!.id, note: note.text, music: musicFile.text, quote: quote.text, photo:photoURL, weather: self.currentWeather, mood: self.mood.description, date: self.today, location: address.text, favorite: isFavorite.isOn, coordinates: [Double(currentLocation.lat), Double(currentLocation.lon)], recordName: self.recordFileName, videoURL: self.videoWebURL){
                }else{
                    //tell the user that the save was not successful, without deleting their work
                    showAlert(message: "Failed to save Journal Entry, please try again")
                }
                
            }
                //Clear not and quote to show user actions are happening
                note.text = ""
                quote.text = ""
                
                //start saving animation
                self.activityIndicator.startAnimating()
            
                // 1 second later, this page will be closed
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1))
                {
                    self.activityIndicator.stopAnimating()
                    _ = self.navigationController?.popViewController(animated: true)
                }
        
        }
    }
    /*
       audio button actions
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
            if self.recordFileName == nil { // when there's no recording
                print("NO recording Found")
                return
            }
            audioRecordBtn.isEnabled = false
            sender.setTitle("Stop", for: .normal)
            // then prepare and play the audio player
            if self.recordFileName == nil {
                print("NIL Record Path when playing")
                return
            }
            else {
                print("Trying to play: \(self.recordFileName!)")
                Model.getInstance.fileOpManager.startPlaying(audioName: self.recordFileName)
            }
        }
        else {
            sender.setTitle("Play", for: .normal)
            audioRecordBtn.isEnabled = true
            Model.getInstance.fileOpManager.stopPlaying()
        }
    }
      // prepare segue
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
    
    // when recording stops, receive file name rather than file path
    func receiveFileName(fileName: String) {
        self.recordFileName = fileName
        print("Record Audio FileName Received: \(self.recordFileName)")
    }
    
    // receive and set video url
    func receiveVideoURL(webURL: URL) {
        self.videoWebURL = webURL
        videoTextfield.text = webURL.absoluteString
        print("Video URL Received: \(self.videoWebURL)")
    }
    
    /**
     Abstracted function to display an alert with a custom message
    **/
    func showAlert(message: String){
        let alert = UIAlertController (title: message, message: "",  preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (actionSave) -> Void in
        }))
        present(alert, animated: true)
        
            }
    
    /**
     Delgate callback to update the weather information to be displayed in the View
     Checks for errors, changes Weather label to an error if there was a problem with API GET
     Has parameter Weather Object that holds weather information returned from the chosen WeatherAPI
     **/
    func updateWeather(weather: Weather) {
        if weather.code == 200{
            self.weatherResultLabel.textColor = UIColor.black
            self.weatherResultLabel.text = weather.conditions+"   "+String(weather.temp)+"°C"
            
        }else
        {
            self.weatherResultLabel.text = weather.message
        }
    }
}
