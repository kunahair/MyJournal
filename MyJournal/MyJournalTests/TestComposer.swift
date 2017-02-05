//
//  TestComposer.swift
//  MyJournal
//
//  Created by Yuanqing Jiang on 5/02/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import XCTest
@testable import MyJournal

/*
 To Rodney and Fardin:
 In our assignment files, each unit test file may contain multiple test cases, rather than one.
 Usually each func represents a single unit test case
 */

class TestComposer: XCTestCase {
    var journalComposer: JournalComposer!
    var defaultJournal: Journal!
    
    override func setUp() {
        super.setUp()
        journalComposer = JournalComposer(composeWidth: 400, composeHeight: 800)
        defaultJournal = Model.getInstance.journalManager.getJournalEntryByIndex(id: 0)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    /*
        1. Test if the journal content can be converted into html
        2. Test if the html can be rendered and saved into pdf,
        it test on both exportHTMLToPDF() and drawPDFUsingRenderer()
        3. Test if the pdf can be converted back to image
     */
    func testExport() {
        /* 1. Convertion*/
        let renderStr = journalComposer.renderJournal(journal: defaultJournal)
        let renderResult = renderStr == nil ? false : true
        XCTAssert(renderResult)
        
        /* 2. Export to PDF*/
        let filePath = journalComposer.exportHTMLToPDF(HTMLContent: renderStr!, journal: defaultJournal)
        var fileSize: UInt64!
        // check if the pdf if empty, fail if it is
        // get pdf file size first:
        do {
            //return [FileAttributeKey : Any]
            let attr = try FileManager.default.attributesOfItem(atPath: filePath)
            fileSize = attr[FileAttributeKey.size] as! UInt64
            
            //if you convert to NSDictionary, you can get file size old way as well.
            let dict = attr as NSDictionary
            fileSize = dict.fileSize()
        } catch {
            print("Error: \(error)")
        }
        
        let exportResult = fileSize >= 0 ? true : false
        XCTAssert(exportResult)
        
        /* 3. PDF to Image*/
        let fileURL = URL(fileURLWithPath: filePath)
        let image = journalComposer.drawImageFromPDF(url: fileURL)
        let imageResult = image != nil ? true : false
        XCTAssert(imageResult)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
