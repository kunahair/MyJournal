//
//  QuoteViewController.swift
//  MyJournal
//
//  Created by XING ZHAO on 16/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import UIKit

class QuoteViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var quotes = ["The best way out is always though","It is not the length of life, but the depth","Glitter is always an option"]
    
    @IBOutlet weak var quoteTable: UITableView!
   // @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.backgroundView = UIImageView(image: UIImage(named: "background"))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        quoteTable.reloadData()
    }

   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return JournalManger.favJournals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     //   let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "quoteCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "quoteCell", for: indexPath) as! QuoteViewCell
        let journal = JournalManger.favJournals[indexPath.item]
        cell.textLabel?.text = journal.quote
        cell.likedQuote = journal
        if journal.favorite == true{
            
        }
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detailView"){
            let cell = sender as! QuoteViewCell
            let detailView = segue.destination as! DetailViewController
            detailView.journalDetail = cell.likedQuote
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

}
