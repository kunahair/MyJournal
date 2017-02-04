//
//  DataDelegate.swift
//  MyJournal
//
//  Created by XING ZHAO on 25/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import Foundation


protocol DataDelegate {
    func parseResult(dataList: Array<Weather>) //to receive weather data
    
    // func receiveFilePath(filePathURL: URL) // to receive file dir after recording
    
    func receiveVideoURL(webURL: URL) // to receive youtube video url
    
    func receiveFileName(fileName: String) // to receive audio file name
}
