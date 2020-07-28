//
//  Notifications.swift
//  LifeSaver
//
//  Created by Minh Vu Nguyen on 27.07.20.
//  Copyright © 2020 Ansgar Gerlicher. All rights reserved.
//

import Foundation
import UserNotifications


class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func userRequest() {
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
    }
    
    func scheduleNotification(notificationTitle: String,identifier: String,notificationBody: String,triggerdate: Date) {
        
        let content = UNMutableNotificationContent() 
        
        content.title = notificationTitle
        content.body = notificationBody
        content.sound = UNNotificationSound.default
        
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: triggerdate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        print(request)
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert,.sound])
    }
    
    func getpendingNotifications(){
            notificationCenter.getPendingNotificationRequests(completionHandler: { (notifications) in
                        print("num of pending notifications \(notifications)")
                        
                    })


    }
}
