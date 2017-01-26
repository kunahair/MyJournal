//
//  FileOpManager.swift
//  MyJournal
//
//  Created by Yuanqing Jiang on 26/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import Foundation
import AVFoundation

/*  Ryan 26Jan:
    This class tends to separate file reading and saving tasks from the VCs
 */

class FileOpManager {
    // audio refs
    var audioRecorder = AVAudioRecorder()
    var audioPlayer = AVAudioPlayer()
    let filemanager = FileManager.default
    
    var audioFileType = ".m4a"
    
    // default recording setting
    var recordSetting = [AVFormatIDKey : kAudioFormatAppleLossless, AVEncoderAudioQualityKey : AVAudioQuality.medium.rawValue, AVEncoderBitRateKey : 320000, AVNumberOfChannelsKey : 2, AVSampleRateKey : 44100.0 ] as [String : Any]
    
    init() {
        // set
    }
    
    
    
    
    
    // set up recorder
    func setupRecorder(delegate: AVAudioRecorderDelegate) {
        // set up everthing in the recorder
        // audio file needs: format, quality, bitrate
        var recordSetting = [AVFormatIDKey : kAudioFormatAppleLossless, AVEncoderAudioQualityKey : AVAudioQuality.medium.rawValue, AVEncoderBitRateKey : 320000, AVNumberOfChannelsKey : 2, AVSampleRateKey : 44100.0 ] as [String : Any]
        // for error display
        var error: NSError?
        
        
        audioRecorder = try! AVAudioRecorder(url: getFileURL(filename: createFileName(type: self.audioFileType)), settings: recordSetting as [String : Any])
        
        if let err = error {
            NSLog("eroooooor")
        }
        else {
            audioRecorder.delegate = delegate
            audioRecorder.prepareToRecord()
        }
        
    }
    
    /*
        File location and url funcs
     */
    func getFileURL(filename: String) -> URL {
        let url = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(filename)
        return url
    }
    func getFilePath(filename: String) -> String {
        return getCacheDir().appendingPathComponent(filename)
    }
    func getCacheDir() -> NSString {
        // grab the path where the audio file is cached
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        
        return paths.object(at: 0) as! NSString
    }
    func createFileName(type: String) -> String {
        let filename = Model.getInstance.getCurrentDateSec().appending(type)
        return filename
    }
}
