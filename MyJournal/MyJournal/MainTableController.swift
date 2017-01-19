//
//  MainTableController.swift
//  MyJournal
//
//  Created by Yuanqing Jiang on 14/01/2017.
//  Copyright © 2017 LegDay. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class MainTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var curTableView: UITableView!
    let hour:Int = 9
    let minute:Int = 0
    
    
    // When extracting arrays from the Model, the Model shall have a function that return a 2D array, the first array will the journals from last week, then last month, then the rest, to utilize the group function of the table view
    var dummyList: [[Journal]] = [[Journal(), Journal(), Journal()], [Journal(), Journal(), Journal()], [Journal(), Journal(), Journal()]]
    
    var headers: [String] = ["This Week", "Last Month", "Previous Journals"]
    
    override func viewWillAppear(_ animated: Bool) {
        curTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleNotifiy(hour: hour, minute: minute)

        // Do any additional setup after loading the view, typically from a nib.

    }
    
    // number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return JournalManger.journals.count
        
    }
    
     //headers
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
   }
    
    // cell reuse
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recell", for: indexPath) as! CustomCell
       // cell.textLabel?.text = dummyList[indexPath.section][indexPath.row].date
        let journal = JournalManger.journals[indexPath.item]
        cell.textLabel?.text = journal.quote
        cell.detailTextLabel?.text = journal.note
        cell.journal = journal
        
        
                //cell.detailTextLabel?.text = "It was a " + dummyList[indexPath.section][indexPath.row].weather + " day" + dummyList[indexPath.section][indexPath.row].weatherEmoji
        
        // add images
        
        //cell.imageView?.image = UIImage(named: "\(dummyList[indexPath.section][indexPath.row].mood)")
        
        // add segue identifier
        
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            JournalManger.DeleteJounal(id: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "DetailViewSegue"){
            let cell = sender as! CustomCell
            let detailView = segue.destination as! DetailViewController
            detailView.journalDetail = cell.journal
        }
    }

    
    // segue to the detail page
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print("cell selected - \(dummyList[indexPath.section][indexPath.row].date)")
        //tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // prepare for segue - pass data
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailView = segue.destination as! DetailViewController
        if segue.identifier == "DetailViewSegue" {
            let selectSection: Int = (curTableView.indexPathForSelectedRow?.section)!
            let selectRow: Int = (curTableView.indexPathForSelectedRow?.row)!
            detailView.journalObj = dummyList[selectSection][selectRow]
        }
    }*/
    
    func scheduleNotifiy(hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "My Journey"
        content.subtitle = "Good Morning"
        content.body = "Seize the day and never let any moment slip away"
        content.badge = 1
        
        var time = DateComponents()
        time.hour = hour
        time.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: true)
        let requestIdentifier = "MyJournalNotification"
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler:{ error in })
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // dummy generation

    
}
