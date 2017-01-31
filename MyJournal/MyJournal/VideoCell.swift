//
//  VideoCell.swift
//  MyJournal
//
//  Created by Yuanqing Jiang on 26/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {
    
    var videoURL: URL?

    @IBOutlet weak var videoPlaybackButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func videoPlayAction(_ sender: Any) {
        
    }
}
