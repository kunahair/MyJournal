//
//  MainTableController.swift
//  MyJournal
//
//  Created by Yuanqing Jiang on 14/01/2017.
//  Copyright © 2017 LegDay. All rights reserved.
//

import Foundation
import UIKit

class MainTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var curTableView: UITableView!
    
    
    // When extracting arrays from the Model, the Model shall have a function that return a 2D array, the first array will the journals from last week, then last month, then the rest, to utilize the group function of the table view
    var dummyList: [[Journal]] = [[Journal(), Journal(), Journal()], [Journal(), Journal(), Journal()], [Journal(), Journal(), Journal()]]
    
    var headers: [String] = ["Last Week", "Last Month", "Previous Journals"]
    
    override func viewWillAppear(_ animated: Bool) {
        //dummyList = createDummy()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    // number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return dummyList.count
    }
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dummyList[section].count
        
    }
    
    // headers
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    // cell reuse
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recell", for: indexPath)
        cell.textLabel?.text = dummyList[indexPath.section][indexPath.row].date
        cell.detailTextLabel?.text = "It was a " + dummyList[indexPath.section][indexPath.row].weather + " day" + dummyList[indexPath.section][indexPath.row].weatherEmoji
        
        // add images
        cell.imageView?.image = UIImage(named: "\(dummyList[indexPath.section][indexPath.row].mood)")
        
        // add segue identifier
        
        
        return cell
        
    }
    
    // segue to the detail page
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print("cell selected - \(dummyList[indexPath.section][indexPath.row].date)")
        //tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // prepare for segue - pass data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailView = segue.destination as! DetailViewController
        if segue.identifier == "DetailViewSegue" {
            let selectSection: Int = (curTableView.indexPathForSelectedRow?.section)!
            let selectRow: Int = (curTableView.indexPathForSelectedRow?.row)!
            detailView.journalObj = dummyList[selectSection][selectRow]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // dummy generation

    
}
