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
    
    var sepArray: [String] = ["", "", "", ""]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = journalDetail!.date
        
        // Do any additional setup after loading the view.
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Table Functions */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 2
        case 4:
            return 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // with header section
        if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
                switch indexPath.row {
                case 0:
                    cell.icon.image = UIImage(named: journalDetail!.weather)
                    cell.label.text = "It was a " + journalDetail!.weather + " day /n"
                case 1:
                    cell.icon.image = #imageLiteral(resourceName: "location-pointer")
                    cell.label.text = "I was at " + journalDetail!.location
                case 2:
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextbodyCell", for: indexPath) as! ImageCell
            cell.imageBody.image = UIImage(named: journalDetail!.photo)
            return cell
        }
        
        // with quote and music 
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextbodyCell", for: indexPath) as! FooterCell
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
        
        
        return tableView.dequeueReusableCell(withIdentifier: "TextbodyCell", for: indexPath) as! FooterCell
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
