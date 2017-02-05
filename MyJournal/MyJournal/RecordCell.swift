//
//  RecordCell.swift
//  MyJournal
//
//  Created by Yuanqing Jiang on 26/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import UIKit

class RecordCell: UITableViewCell {

    var recordName: String?
    
    @IBOutlet weak var recordPlaybackButton: UIButton!
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
            if recordName == nil {
                print("Record URL NIL -- DetailPage")
            }
            else {
                Model.getInstance.fileOpManager.startPlaying(audioName: self.recordName!)
            }
            recordPlayBtn.titleLabel?.text = "Stop"
        }
        else {
            Model.getInstance.fileOpManager.stopPlaying()
            recordPlayBtn.titleLabel?.text = "Play"
        }
    }
}
