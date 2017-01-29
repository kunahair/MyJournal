//
//  WebViewController.swift
//  MyJournal
//
//  Created by Yuanqing Jiang on 26/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import Foundation
import UIKit

class WebViewController: UIViewController {
    
    var webURL: URL?
    var dataDelegate: DataDelegate?
    
    @IBOutlet weak var saveVideoBtn: UIBarButtonItem!
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        self.title = "YouTube"
        if webURL == nil {
            webURL = URL(string: "https://www.youtube.com/")
        }
        let webRequest = URLRequest(url: webURL!)
        webView.loadRequest(webRequest)
        
        // check if its get or view
        if dataDelegate == nil { // not launched from edit
            saveVideoBtn.isEnabled = false
        }
    }
    @IBAction func SaveVideo(_ sender: Any) {
        webURL = webView.request!.url!
        if dataDelegate != nil && webURL != nil{
            dataDelegate?.receiveVideoURL(webURL: self.webURL!)
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}
