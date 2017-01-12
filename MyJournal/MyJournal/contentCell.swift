//
//  ContentCell.swift
//  MyJournal
//
//  Created by WEIZHUO TIAN on 12/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import UIKit

class ContentCell: UITableViewCell {

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var content: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
