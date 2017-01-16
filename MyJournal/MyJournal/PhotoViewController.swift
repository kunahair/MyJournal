//
//  PhotoViewController.swift
//  MyJournal
//
//  Created by XING ZHAO on 15/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{

    @IBOutlet weak var photoView: UICollectionView!
    
    var photos = ["winter", "puppy","lake","snow","automn","road","koala","cloud","city"]
    var menu = ["Photo", "Quate","Music"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoView.delegate = self
        self.photoView.dataSource = self
        // Do any additional setup after loading the view.
    }
       
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoViewCell
        cell.likedPhotos.image = UIImage(named: photos[indexPath.row])
        return cell
    }

}
