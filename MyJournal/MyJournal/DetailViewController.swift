//
//  DetailViewController.swift
//  MyJournal
//
//  Created by Yuanqing Jiang on 15/01/2017.
//  Copyright © 2017 LegDay. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var journalDetail:Journal?
    
    var contentArray: [[String]] = []
    
    //Journal Headings
    var sepArray: [String] = ["How I Felt", "Journal", "Shot of the Day", "A Bit More"]
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var favBtnOutlet: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ""
        //just in case, grab it again from the model by key
        journalDetail = Model.getInstance.journalManager.getJournalEntryByKey(key: journalDetail!.id)
        
        // enable auto layout
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        // Do any additional setup after loading the view.
        
        sepArray[0] = journalDetail!.date
        if journalDetail!.favorite {
            favBtnOutlet.image = UIImage(named: "heartfill")
        }
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Table Functions */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    //Divide into sections for each journal heading
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 2
        default:
            return 1
        }
    }
    
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
        
        // with body section
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextbodyCell", for: indexPath) as! TextbodyCell
            cell.label.text = journalDetail!.note
            return cell
        }
        
        // with image section
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageCell
            if journalDetail!.photo == "defaultphoto"
            {
                cell.imageBody.image = UIImage(named: "defaultphoto")!
            }else{
                cell.imageBody.image = UIImage(contentsOfFile: journalDetail!.photo)
            }
            return cell
        }
        
        // with quote and music 
        if indexPath.section == 3 {
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
        
        
        return tableView.dequeueReusableCell(withIdentifier: "FooterCell", for: indexPath) as! FooterCell
    }
    
    // prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailToEditSegue" {
            
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
    
    //btns
    
    @IBAction func favBtn(_ sender: Any) {
        if journalDetail != nil {
            if journalDetail!.favorite { // when it is true - favourite
                // modify the model and then local copy
                if Model.getInstance.journalManager.setJournalFavouriteByKey(key: journalDetail!.id) {
                    // on successful fav-set, change local copy
                    localFavSet(set: false)
                }
            }
            else { // when it is false, not favourite
                if Model.getInstance.journalManager.setJournalFavouriteByKey(key: journalDetail!.id) {
                    localFavSet(set: true)
                }
            }
        }
    }
    
    
    @IBAction func delBtn(_ sender: Any) {
        // on successful deletion
        if Model.getInstance.journalManager.deleteJournalEntryByKey(key: journalDetail!.id) { // success
            self.navigationController?.popViewController(animated: true)
        }
        else {
            print("deletion failed on: " + "\(journalDetail!.id)")
        }
    }
    
    func localFavSet(set: Bool) {
        if set { // when set to fav
            // set btn appearence
            favBtnOutlet.image = UIImage(named: "heartfill")
        }
        else { // when set to not fav
            favBtnOutlet.image = UIImage(named: "heart")
        }
        // finally set the local copy
        journalDetail!.favorite = set
    }

}
