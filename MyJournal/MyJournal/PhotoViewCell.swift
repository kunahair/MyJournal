//
//  PhotoViewCell.swift
//  MyJournal
//
//  Created by XING ZHAO on 15/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import UIKit

class PhotoViewCell: UICollectionViewCell {
    
    var favorite:Journal?
    
    
    @IBOutlet weak var likedPhotos: UIImageView!
    
    @IBOutlet weak var likedDate: UILabel!
    
}
