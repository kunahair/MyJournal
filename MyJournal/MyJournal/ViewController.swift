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
    let hour:Int = 15
    let minute:Int = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Notification for user to enter journal entry for the day (not used in submission)
        //scheduleNotifiy(hour: hour, minute: minute)
       // UNUserNotificationCenter.current().delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Notification for user to enter journal entry for the day (not used in submission)
    /**
    func scheduleNotifiy(hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "My Journey"
        content.subtitle = "Good Morning"
        content.body = "Seize the day and never let any moment slip away"
        content.badge = 1
        
        var time = DateComponents()
        time.hour = hour
        time.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: true)
        let requestIdentifier = "MyJournalNotification"
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler:{ error in })
    }
 **/

 
   }

