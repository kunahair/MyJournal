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
    var hasAlbum: Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup photo view (collection boilerplate)
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
    
    //Draw the cells for Collection View
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Get Cell from reusable queue
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoViewCell
        //Get Journal entry
        let journal = Model.getInstance.journalManager.getJournalFavouriteArray()[indexPath.item]
        
        //Populate cell with entry data
        //Also gets image from saved if it is set
        cell.likedDate.text = journal.date
        if journal.photo == "defaultphoto"
        {
            cell.likedPhotos.image = UIImage(named: "defaultphoto")!
        }else{
            
            cell.likedPhotos.image = UIImage(contentsOfFile: Model.getInstance.getFilePathFromDocumentsDirectory(filename: journal.photo))
        }
        
        //return the cell to be drawn
        cell.favorite = journal
        return cell
    }
    
    //Prepare for Segue into details view page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detailView"){
            let cell = sender as! PhotoViewCell
            let detailView = segue.destination as! DetailViewController
            detailView.journalDetail = cell.favorite
        }
    }
    
}
