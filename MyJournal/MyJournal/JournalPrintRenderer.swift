//
//  JournalPrintRenderer.swift
//  MyJournal
//
//  Created by Yuanqing Jiang on 1/02/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import UIKit

class JournalPrintRenderer: UIPrintPageRenderer {
    var pageWidth: CGFloat?
    var pageHeight: CGFloat?
    
    let A4PageWidth: CGFloat = 595.2
    let A4PageHeight: CGFloat = 841.8
    
    init(width: CGFloat, height: CGFloat) {
        super.init()
        self.pageWidth = width
        self.pageHeight = height
        
        let pageFrame = CGRect(x: 0, y: 0, width: pageWidth!, height: pageHeight!)
        
        // Set the page frame.
        self.setValue(NSValue(cgRect: pageFrame), forKey: "paperRect")
        
        // Set the horizontal and vertical insets (that's optional).
        self.setValue(NSValue(cgRect: pageFrame), forKey: "printableRect")
        self.setValue(NSValue(cgRect: pageFrame.insetBy(dx: 1.0, dy: 1.0)), forKey: "printableRect")
    }

}
