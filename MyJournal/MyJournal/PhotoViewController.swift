//
//  PhotoViewController.swift
//  MyJournal
//
//  Created by XING ZHAO on 15/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import UIKit
import Photos

class PhotoViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{

    @IBOutlet weak var photoView: UICollectionView!
    let albumName = "My Journal"
    var photos = ["winter", "puppy","lake","snow","automn","road","koala","cloud","city"]
    var hasAlbum: Bool = false
    var assetCollection: PHAssetCollection = PHAssetCollection()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoView.delegate = self
        self.photoView.dataSource = self
        self.photoView.backgroundView = UIImageView(image: UIImage(named: "background"))
        // Do any additional setup after loading the view.
        /* 
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "name = %@", albumName)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
       
        //check if the album folder exists
        if collection.firstObject != nil{
            self.hasAlbum = true  //found the my journal album
            self.assetCollection = collection.firstObject! as PHAssetCollection
        }else{
            NSLog("My Journal folder does not exist", albumName)
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.albumName)
            }, completionHandler: {success, error in
                NSLog("My Journal album is created -> %@", ((success) ? "Success" : "Error!"))
                self.hasAlbum = success ? true : false
                
            })
        }*/

    }
    
    override func viewWillAppear(_ animated: Bool) {
        photoView.reloadData()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return JournalManger.journals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoViewCell
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "quoteCell", for: indexPath) as! QuoteViewCell
        let journal = JournalManger.journals[indexPath.item]
        cell.likedDate.text = journal.date
        cell.likedPhotos.image = UIImage(named: journal.photo)
        
        cell.favorite = journal
        
        return cell

        
        
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detailView"){
            let cell = sender as! PhotoViewCell
            let detailView = segue.destination as! DetailViewController
            detailView.journalDetail = cell.favorite
        }
    }
    
}
