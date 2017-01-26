//
//  RecordCell.swift
//  MyJournal
//
//  Created by Yuanqing Jiang on 26/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import UIKit

class RecordCell: UITableViewCell {

    var recordURL: URL?
    
    @IBOutlet weak var recordPlayBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func recordPlayAction(_ sender: Any) {
        
        if recordPlayBtn.titleLabel?.text == "Play" {
            if recordURL == nil {
                print("Record URL NIL -- DetailPage")
            }
            else {
                Model.getInstance.fileOpManager.startPlaying(audioURL: recordURL!)
            }
            recordPlayBtn.titleLabel?.text = "Stop"
        }
        else {
            Model.getInstance.fileOpManager.stopPlaying()
            recordPlayBtn.titleLabel?.text = "Play"
        }
    }
}
