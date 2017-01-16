//
//  ViewController.swift
//  MyJournal
//
//  Created by XINGZHAO on 12/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // UNUserNotificationCenter.current().delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    @IBAction func scheduleNotifiy() {
        let content = UNMutableNotificationContent()
        content.title = "My Journey"
        content.subtitle = "which breed you like best"
        content.body = "I like poodle best but doodle is also fine"
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        let requestIdentifier = "Quiz"
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler:{ error in })
        //UNUserNotificationCenter.current()
    }*/

 
   }

