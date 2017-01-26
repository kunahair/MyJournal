//
//  DataDelegate.swift
//  MyJournal
//
//  Created by XING ZHAO on 25/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import Foundation


protocol DataDelegate {
    func parseResult(dataList: Array<Weather>)
    
    // Ryan 26Jan: added some more stuff here to pass arround data :)
    
    func receiveFilePath(filePathURL: URL) // to receive file dir after recording
    
    func receiveVideoURL(webURL: URL) // to receive youtube video url
}
