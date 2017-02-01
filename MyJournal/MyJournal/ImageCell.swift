//
//  ImageCell.swift
//  MyJournal
//
//  Created by Yuanqing Jiang on 18/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {

    @IBOutlet weak var imageBody: UIImageView!
    
    @IBOutlet weak var noteBody: UILabel!
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
