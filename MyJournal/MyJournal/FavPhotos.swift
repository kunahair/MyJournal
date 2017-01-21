//
//  FavPhotos+CoreDataClass.swift
//  MyJournal
//
//  Created by XING ZHAO on 20/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import Foundation
import CoreData

class FavPhotos: NSManagedObject {

    @nonobjc class func fetchRequest() -> NSFetchRequest<FavPhotos> {
        return NSFetchRequest<FavPhotos>(entityName: "FavoritePhotos");
    }
    
    @NSManaged var photoURL: String?

}
