//
//  QuoteViewCell.swift
//  MyJournal
//
//  Created by XING ZHAO on 16/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import UIKit

class QuoteViewCell: UITableViewCell {
    @IBOutlet weak var likedQuotes: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
