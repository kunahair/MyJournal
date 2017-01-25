//
//  MapCell.swift
//  MyJournal
//
//  Created by Yuanqing Jiang on 18/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import UIKit
import MapKit

class MapCell: UITableViewCell {

    @IBOutlet weak var mapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        super.selectionStyle = UITableViewCellSelectionStyle.none

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func drawMap(id: String) { // draw map with Journal ID, called in TableView
        let journal = Model.getInstance.journalManager.getJournalEntryByKey(key: id)
        let (mapRegion, mapAnnotation) = Model.getInstance.getMapInfo(journal: journal!)
        
        mapView.region = mapRegion
        mapView.addAnnotation(mapAnnotation)
    }
}
