//
//  FooterCell.swift
//  MyJournal
//
//  Created by Yuanqing Jiang on 19/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import UIKit

class FooterCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        super.selectionStyle = UITableViewCellSelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
