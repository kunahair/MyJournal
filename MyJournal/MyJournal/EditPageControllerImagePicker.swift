//
//  EditPageControllerImagePicker.swift
//  MyJournal
//
//  Created by Josh Gerlach on 28/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import UIKit

/**
 Extension to handle the Image Picker callbacks for EditPageController
 **/
extension EditPageController {
    
    //assign selected photo to the scene
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedPhoto = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        //save selected photo data and get the url
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.photo.image = selectedPhoto
            }
            //get the saving time as the name of photo data
            let dateStr = Model.getInstance.getCurrentDateSec()
            self.photoURL = String(format: "%@.png", dateStr)
            let photoData = UIImagePNGRepresentation(selectedPhoto!)
            
            let photoPaths = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(self.photoURL)
            //write data
            print("DocPath: \(try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).absoluteString)")
            print("PhotoPath: \(photoPaths.absoluteString)")
            do {
                try photoData?.write(to: photoPaths, options: .atomic)
            } catch {
                print(error)
            }
            
            let paths: NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
            let documentsDir: NSString = paths.object(at: 0) as! NSString
            
            self.photoPath  = documentsDir.appendingPathComponent(self.photoURL!)
            
            print("picture : "+"\(self.photoPath)")
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
