//
//  TestAudio.swift
//  MyJournal
//
//  Created by Yuanqing Jiang on 5/02/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import XCTest
import AVFoundation
@testable import MyJournal

/*
    To Rodney and Fardin:
    In our assignment files, each unit test file may contain multiple test cases, rather than one. 
    Usually each func represents a single unit test case
 */
class TestAudio: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /*
        Test if the the recorder can be initialised
     */
    func testRecorderSetup() {
        let fileManager = Model.getInstance.fileOpManager
        let editVC = EditPageController()
        // fail if the audio recorder is nil
        XCTAssert(fileManager.setupRecorder(avDelegate: editVC as AVAudioRecorderDelegate, dataDelegate: editVC as DataDelegate))
    }
    
    /*
        test if the av player can be initialised
     */
    func testPlayerSetup() {
        let fileManager = Model.getInstance.fileOpManager
        // get a default audioURL from database
        let name = Model.getInstance.journalManager.getJournalEntryByIndex(id: 0).recordName!
        let url = Model.getInstance.getFilePathFromDocumentsDirectory(filename: name)
        XCTAssert(fileManager.preparePlayer(audioURL: URL(fileURLWithPath: url)))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
