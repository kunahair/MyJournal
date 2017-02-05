//
//  CustomCell.swift
//  MyJournal
//
//  Created by Yuanqing Jiang on 16/01/2017.
//  Copyright © 2017 LegDay. All rights reserved.
//

import UIKit

/**
 Custom cell for TableView
 **/
class CustomCell: UITableViewCell {

    var journal:Journal?
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
