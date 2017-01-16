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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (quotes.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "quoteCell")
      //  let cell = tableView.dequeueReusableCell(withIdentifier: "quotecell", for: indexPath) as! QuoteViewCell
       
        cell.textLabel?.text = quotes[indexPath.row]
      //  cell.textLable?.text = quotes[indexPath.row]
        return cell
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
