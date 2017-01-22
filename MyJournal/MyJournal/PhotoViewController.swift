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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoView.delegate = self
        self.photoView.dataSource = self
        self.photoView.backgroundView = UIImageView(image: UIImage(named: "background"))
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photoView.reloadData()
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Model.getInstance.journalManager.getJournalFavouriteArray().count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoViewCell
        let journal = Model.getInstance.journalManager.getJournalFavouriteArray()[indexPath.item]
        cell.likedDate.text = journal.date
        if journal.photo == "defaultphoto"
        {
            cell.likedPhotos.image = UIImage(named: "defaultphoto")!
        }else{
            cell.likedPhotos.image = UIImage(contentsOfFile: journal.photo)
        }
        
        
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
