//
//  NotificationViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 08/05/24.
//

import UIKit
import NotificationCenter

let week11Storyboard = UIStoryboard(name: "week11", bundle: .main)

class NotificationViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().getNotificationSettings { setting in
            switch setting.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization()
                break
            case .denied:
                self.requestAuthorization()
                break
            case .authorized, .provisional:
                print("done")
                break
            @unknown default:
                print("defult")
                break
            }
        }
    }
    
    func requestAuthorization() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success && error == nil {
                print("All set!")
            }
        }
        
    }

    @IBAction func localNofificationButtonTapped(_ sender: UIButton) {
        
        let content = UNMutableNotificationContent()
        content.title = "Test Notification"
        content.body = "This is Local Notification for testing"
        content.sound = .default
        content.userInfo = [
            "name" : "sample test",
            "email" : "test@gmail.com"
        ]
        
        let okButton = UNNotificationAction(identifier: "okAction", title: "Okay", options: [])
        let cancelButton = UNNotificationAction(identifier: "cancelAction", title: "Cancle", options: [.destructive])
        
        let category = UNNotificationCategory(identifier: "sample", actions: [okButton, cancelButton], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        content.categoryIdentifier = "sample"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: "LocalTest\(UUID().uuidString)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }

}
