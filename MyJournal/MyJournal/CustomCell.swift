//
//  CustomCell.swift
//  MyJournal
//
//  Created by Yuanqing Jiang on 16/01/2017.
//  Copyright © 2017 LegDay. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    var journal:Journal?
    //var journal:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
