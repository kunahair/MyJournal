//
//  JournalComposer.swift
//  MyJournal
//
//  Created by Yuanqing Jiang on 1/02/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import UIKit

class JournalComposer: NSObject {
    var pathToHTMLTemplate:String? = Bundle.main.path(forResource: "journal", ofType: "html")
    
    var composeWidth: CGFloat!
    var composeHeight: CGFloat!
    
    override init() {
        super.init()
    }
    
    init(composeWidth: CGFloat, composeHeight: CGFloat) {
        super.init()
        self.composeWidth = composeWidth
        self.composeHeight = composeHeight
    }
    
    func setUpComposer(resource: String, type: String, composeWidth: CGFloat, composeHeight: CGFloat) {
        self.pathToHTMLTemplate = Bundle.main.path(forResource: resource, ofType: type)
        self.composeWidth = composeWidth
        self.composeHeight = composeHeight
    }
    
    func renderJournal(journal journalDetail: Journal) -> String?{
        
        let date = journalDetail.date
        let weather = "It was a " + journalDetail.weather + " day"
        let address = "I was at " + journalDetail.location
        let mood = "I was feeling " + journalDetail.mood
        let content = journalDetail.note
        let photo = journalDetail.photo
        
        do {
            
        var HTMLContent = try String(contentsOfFile:pathToHTMLTemplate!)
        
        // Replace all the placeholders with real values
        HTMLContent = HTMLContent.replacingOccurrences(of: "#Date#", with: date)
        HTMLContent = HTMLContent.replacingOccurrences(of: "#Weather#", with: weather)
        HTMLContent = HTMLContent.replacingOccurrences(of: "#Address#", with: address)
        HTMLContent = HTMLContent.replacingOccurrences(of: "#Mood#", with: mood)
        HTMLContent = HTMLContent.replacingOccurrences(of: "#JournalContent#", with: content)
        HTMLContent = HTMLContent.replacingOccurrences(of: "#PhotoSource#", with: photo)
            print(photo)
            return HTMLContent 
        }
        catch {
            print("Unable to open and use HTML template files.")
        }
        
        return nil
    }
    
    // export print
    func exportHTMLToPDF(HTMLContent: String, journal: Journal) -> String{
        // for actual drawing
        let journalPrintRenderer = JournalPrintRenderer(width: composeWidth, height: composeHeight)
        // formatter to fromater HTML mark up, and then added to the printRednerer
        let printFormatter = UIMarkupTextPrintFormatter(markupText: HTMLContent)
        journalPrintRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        
        // custom function to return drawn PDF, also pass in a UIImage from the journal
        // read the String to UIImage first
        let photo = UIImage(contentsOfFile: journal.photo)
        var pdfData = drawPDFUsingRenderer(renderer: journalPrintRenderer, photo: photo!)        // file name to pass and save
        let pdfFilename = Model.getInstance.fileOpManager.getFilePath(filename: Model.getInstance.fileOpManager.createFileName(type: ".pdf"))
        pdfData.write(toFile: pdfFilename, atomically: true)
        print("PDF SAVED: " + pdfFilename)
        return pdfFilename
    }
    
    // actual drawing
    func drawPDFUsingRenderer(renderer: JournalPrintRenderer, photo: UIImage) -> NSData{
        let data = NSMutableData()
        let photoHeight = (composeWidth/photo.size.width)*photo.size.height
        UIGraphicsBeginPDFContextToData(data, CGRect(x:0, y:0, width:composeWidth, height:(composeHeight+photoHeight)), nil)

        UIGraphicsBeginPDFPage()
        renderer.drawPage(at: 0, in: UIGraphicsGetPDFContextBounds())
        let curContext = UIGraphicsGetCurrentContext()
        // convert UIImage to CI then CG
        let cgi = CIImage(image: photo)?.applyingOrientation(4)
        // image rect
        let imageRect = CGRect(x: 0, y: composeHeight, width: composeWidth, height: photoHeight)
        curContext!.draw(convertCIImageToCGImage(inputImage: cgi!), in: imageRect)
        UIGraphicsEndPDFContext()
        return data
    }
    
    func drawImageFromPDF(url: URL) -> UIImage? {
        guard let document = CGPDFDocument(url as CFURL) else { return nil }
        guard let page = document.page(at: 1) else { return nil }
        
        let pageRect = page.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img: UIImage = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)
            
            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height);
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0);
            
            ctx.cgContext.drawPDFPage(page);
        }
        
        return img
    }
    
//    func drawFinalImage(pdfImage: UIImage, photo: UIImage) -> UIImage? {
//        // start new context to add two images, first calculate the corrected size
//        let newWidth = pdfImage!.size.width
//        let scaleFactor = newWidth/photo.size.width
//        let newHeight = photo.size.height*scaleFactor + pdfImage!.size.height
//        // set new size for photo
//        
//        UIGraphicsBeginImageContext(CGSize(width: newWidth, height:newHeight))
//        pdfImage!.draw(at: CGPoint.zero) // draw the pdf image at the start of the context
//        let photoRect = CGRect(x:0, y:pdfImage!.size.height, width:newWidth, height:photo.size.height*scaleFactor) // define a scaled rect for the photo to draw
//        photo.draw(in: photoRect) //drawing
//        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        UIImageWriteToSavedPhotosAlbum(finalImage!, nil, nil, nil) // saves it in the album
//    }
    
    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage! {
        let context = CIContext(options: nil)
        if context != nil {
            return context.createCGImage(inputImage, from: inputImage.extent)
        }
        return nil
    }
}
