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
    ^ Currently handles audio record func, can later on handle photo related stuff as well
 */

class FileOpManager {
    // audio refs
    var audioRecorder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    let filemanager = FileManager.default
    
    var audioFileType = ".m4a"
    
    var dataDelegate : DataDelegate!
    
    // default recording setting
    var recordSetting = [AVFormatIDKey : kAudioFormatAppleLossless, AVEncoderAudioQualityKey : AVAudioQuality.medium.rawValue, AVEncoderBitRateKey : 320000, AVNumberOfChannelsKey : 2, AVSampleRateKey : 44100.0 ] as [String : Any]
    
    init() {
        // set
    }
    
    
    
    
    
    // set up recorder
    // this function needs to be called every time when page is loading so that the record file name will be unique and consistent with the timestamp of: YY-MM-DD-HH-MM-SS
    func setupRecorder(avDelegate: AVAudioRecorderDelegate, dataDelegate: DataDelegate) {
        // set up everthing in the recorder
        // audio file needs: format, quality, bitrate
        var recordSetting = [AVFormatIDKey : kAudioFormatAppleLossless, AVEncoderAudioQualityKey : AVAudioQuality.medium.rawValue, AVEncoderBitRateKey : 320000, AVNumberOfChannelsKey : 2, AVSampleRateKey : 44100.0 ] as [String : Any]
        // for error display
        //var error: NSError?
        
        
        audioRecorder = try! AVAudioRecorder(url: getFileURL(filename: createFileName(type: self.audioFileType)), settings: recordSetting as [String : Any])
        
        print("Trying to create recorder at: \(audioRecorder!.url.absoluteString)")
        
        if audioRecorder != nil {
            self.dataDelegate = dataDelegate
            audioRecorder!.delegate = avDelegate
            audioRecorder!.prepareToRecord()
        }
        
    }
    
    // prepare AV player
    func preparePlayer(audioURL: URL) {
        print("Preparing AVPlayer: \(audioURL)")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
        } catch let error as NSError {
            print("AVPlayer instantiation Error: \(error.localizedDescription)")
            audioPlayer = nil
        }
        if audioPlayer == nil {
            print("Tried to create AVPlayer but Failed")
        }
        else { // when successfully created
            audioPlayer!.delegate = dataDelegate as? AVAudioPlayerDelegate
            audioPlayer!.prepareToPlay()
            audioPlayer!.volume = 1.0
        }
    }
    
    /*
        Start, stop, record funcs, send filepath back through delegate when finish recording
     */
    func startRecording() {
        if audioRecorder == nil {
            print("ERROR: NIL AudioRecorder")
            return
        }
        audioRecorder!.record()
        print("Audio Recording Starts")
    }
    
    func stopRecording() {
        if audioRecorder == nil {
            print("ERROR: NIL AudioRecorder")
            return
        }
        audioRecorder!.stop()
        dataDelegate.receiveFilePath(filePathURL: audioRecorder!.url) // returns the URL
    }
    
    func startPlaying(audioURL: URL) {
        preparePlayer(audioURL: audioURL)
        audioPlayer!.play()
    }
    
    func stopPlaying() {
        audioPlayer!.stop()
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
