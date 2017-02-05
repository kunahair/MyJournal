//
//  DetailViewController.swift
//  MyJournal
//
//  Created by Yuanqing Jiang on 15/01/2017.
//  Copyright © 2017 LegDay. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //Local Journal Entry that is being viewed, and also is updated in sympathy with the Model
    var journalDetail:Journal?
    
    
    /*
        Menu refs
     */
    
    @IBOutlet var rootView: UIView!
    @IBOutlet weak var edit: UIButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuTrailing: NSLayoutConstraint! // open: -16; hidden: -200
    var menuShowing = false
    
    /*
        Exporting ref and render
     */
    // let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
    
    //Journal Headings
    var sepArray: [String] = ["How I Felt", "Journal", "A Bit More", "I Was at", "Other stuff"]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favBtnOutlet: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ""
        //just in case, grab it again from the model by key
        if journalDetail != nil{
            journalDetail = Model.getInstance.journalManager.getJournalEntryByKey(key: journalDetail!.id)
        }
        
        
        // enable auto layout
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        // Do any additional setup after loading the view.

        if journalDetail!.favorite {
            favBtnOutlet.image = UIImage(named: "heartfill")
        }
        
        // hide menu get shadow
        hideMenu()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Before the view appears, check that it has not been modified in the model
        //Get the journal entry from the model
        let journalUpdate:Journal? = Model.getInstance.journalManager.getJournalEntryByKey(key: journalDetail!.id)
        
        //Check status of Journal Entry, if it has been deleted then go back a page, or update view for any changes
        //If it is nil, then go back one view (either main table view or collection view)
        if journalUpdate == nil {
            let _ = navigationController?.popViewController(animated: true)
        }else{
            //Otherwise set the favourite, change Journal Detail Entry to include new changes, and reload the view
            localFavSet(set: journalUpdate!.favorite)
            journalDetail = journalUpdate
            tableView.reloadData()
        }
        
        //If the menu is showing when view is being reloaded, then hide it, looks nicer
        if menuShowing {
            hideMenu()
        }
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
            }
    
    // prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "WebViewSegue" {
            let destination = segue.destination as! WebViewController
            destination.webURL = journalDetail!.videoURL
        }
        
        //Xing : pass the data to edit page
        if segue.identifier == "EditJournalSegue" {
            let editView = segue.destination as! EditPageController
            
            editView.journalDetail = journalDetail

        }
        if segue.identifier == "ExportPreviewSegue" {
            let destination = segue.destination as! ExportViewController
            destination.journal = self.journalDetail!
        }
    }

    
    /**
     When favourite button is pressed, toggle the value in the database and memory model
     On success update the button view and change the local value
    **/
    @IBAction func favBtn(_ sender: Any) {
        if journalDetail != nil {
            if Model.getInstance.journalManager.toggleJournalFavouriteByKey(key: journalDetail!.id)
            {
                localFavSet(set: !journalDetail!.favorite)
            }
        }
    }
    
    
    @IBAction func delBtn(_ sender: Any) {
        // on successful deletion
        // create the alert
        let alert = UIAlertController(title: "Warning", message: "Do you wnat to proceed to delete this journal?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (actionDelete) -> Void in
            if Model.getInstance.journalManager.deleteJournalEntryByKey(key: self.journalDetail!.id) { // success
                _ = self.navigationController?.popViewController(animated: true)
            }
            else {
                print("deletion failed on: " + "\(self.journalDetail!.id)")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
       
       
    }
    
    /**
     Update the Favourite button view to be filled or empty when user toggles the value
     Set the local variable to keep in line with Model
    **/
    func localFavSet(set: Bool) {
        if set {
            // when set to fav set btn appearence
            favBtnOutlet.image = UIImage(named: "heartfill")
        }
        else { // when set to not fav
            favBtnOutlet.image = UIImage(named: "heart")
        }
        // finally set the local copy
        journalDetail!.favorite = set
    }
}


/**
 TableView Delegate and custom functions
 **/
extension DetailViewController {
    
    /* Table Functions */
    func numberOfSections(in tableView: UITableView) -> Int {
        return sepArray.count
    }
    
    //Divide into sections for each journal heading
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 1
        case 2:
            return 2
        case 3:
            return 1
        case 4:
            return 2
        default:
            return 1
        }
    }
    
    /**
     Populate headings of each section
     **/
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sepArray[section]
    }
    
    //Populate cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // with header section
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
            switch indexPath.row {
            case 0:
                cell.icon.image = UIImage(named: "calendar")
                cell.label.text = journalDetail!.date
            case 1:
                cell.icon.image = UIImage(named: journalDetail!.weather)
                cell.label.text = "It was a " + journalDetail!.weather + " day"
            case 2:
                cell.icon.image = UIImage(named: "location-pointer")
                cell.label.text = "I was at " + journalDetail!.location
            case 3:
                cell.icon.image = UIImage(named: journalDetail!.mood)
                cell.label.text = "I was feeling " + journalDetail!.mood
            default:
                return cell
            }
            return cell
        }
        
        
        // with image section
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageCell
            cell.noteBody.text = journalDetail!.note
            if journalDetail!.photo == "defaultphoto"
            {
                cell.imageBody.image = UIImage(named: "defaultphoto")!
            }else{
                cell.imageBody.image = UIImage(contentsOfFile: Model.getInstance.getFilePathFromDocumentsDirectory(filename: journalDetail!.photo))
            }
            return cell
        }
        
        // with quote and music
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FooterCell", for: indexPath) as! FooterCell
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = "Quote of the Day"
                cell.label.text = journalDetail!.quote
            case 1:
                cell.titleLabel.text = "Music of the Day"
                cell.label.text = journalDetail!.music
            default:
                return cell
            }
            return cell
        }
        
        // with map cell
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath) as! MapCell
            cell.drawMap(id: journalDetail!.id)
            return cell
        }
        
        // with video and record cell
        if indexPath.section == 4 {
            switch indexPath.row {
            case 0:
                //Get reference to Cell from queue as a VideoCell
                let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoCell
                //Get the videoURL for this Journal Entry
                //If it not nil, load the videolink
                let videoURL:URL? = journalDetail!.videoURL
                if videoURL != nil
                {
                    cell.videoURL = journalDetail!.videoURL
                } else {
                    //Otherwise hide the playback button
                    cell.videoPlaybackButton.isHidden = true
                }
                
                return cell
            case 1:
                //Get reference to the Cell from queue as a RecordCell
                let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath) as! RecordCell
                //Get the record URL for this Journal Entry
                //If it is not nil, load the Record Link
                let recordName: String? = self.journalDetail!.recordName
                if recordName != nil
                {
                    cell.recordName = recordName
                }else {
                    //Otherwise hide the record playback button
                    cell.recordPlaybackButton.isHidden = true
                }
                return cell
            default:
                return UITableViewCell()
            }
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "FooterCell", for: indexPath) as! FooterCell
    }
    
    //If the menu is showing when user selects away from the menu, hide the menu
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if menuShowing{
            hideMenu()
        }
    }
}

/**
 Custom Menu Functions and related button listeners
 **/
extension DetailViewController {
    /*
     Slide menu funcs & actions
     */
    
    @IBAction func menuSlide(_ sender: Any) {
        toggleMenu()
    }
    
    /*
     Export action
     */
    
    @IBAction func exportAction(_ sender: Any) {
        // hide the menu first
        hideMenu()
        
    }
    
    /**
     Hide the Custom Menu
     **/
    fileprivate func hideMenu(){
        menuTrailing.constant = -200.0
        menuView.alpha = 1
        menuShowing = false
        
        // add animation
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        
    }
    
    /**
     Show the Custom Menu with animation
     **/
    fileprivate func showMenu(){
        menuTrailing.constant = -20.0
        menuView.alpha = 1
        menuShowing = true
        
        // add animation
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    /**
     Toggle the Custom Menu with animation
     **/
    fileprivate func toggleMenu() {
        if menuShowing { // is showing
            hideMenu()
        }
        else {
            showMenu()
        }
    }
}
