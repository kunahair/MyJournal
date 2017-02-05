//
//  ExportViewController.swift
//  MyJournal
//
//  Created by Yuanqing Jiang on 1/02/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import UIKit

class ExportViewController: UIViewController {
    
    var journal: Journal!
    var journalComposer: JournalComposer?
    var HTMLContent: String?
    
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        journalComposer = JournalComposer(composeWidth: webView.scrollView.contentSize.width, composeHeight: webView.scrollView.contentSize.height+90.0)
        
        HTMLContent = journalComposer!.renderJournal(journal: journal)
        
        webView.loadHTMLString(HTMLContent!, baseURL: NSURL(string:journalComposer!.pathToHTMLTemplate!) as URL?)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        let pdfPath = journalComposer?.exportHTMLToPDF(HTMLContent: HTMLContent!, journal: self.journal)
        let pdfURL = URL(fileURLWithPath: pdfPath!)
        let pdfImage = journalComposer?.drawImageFromPDF(url: pdfURL)
        // save image
        UIImageWriteToSavedPhotosAlbum(pdfImage!, nil, nil, nil)
        
        // feedback
        let alert = UIAlertController(title: "Success", message: "Your journal has just been exported to your Photo Library and PDF", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Awesome!", style: UIAlertActionStyle.cancel, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
   
}
