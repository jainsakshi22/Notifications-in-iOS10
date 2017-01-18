//
//  AppDelegate.swift
//  UserNotification
//
//  Created by Jain Sakshi on 17/01/17.
//  Copyright © 2017 Sakshi. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert]) { (accepted, error) in
            
            if (!accepted) {
//                let alertController = UIAlertController(title: "", message: "You can enable notifications in settings tab", preferredStyle: .alert)
//                
//                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                alertController.addAction(defaultAction)
//                
//                self.window?.rootViewController?.present(alertController, animated: true, completion: nil);
                print("Notifications access denied")
                
            }
        }
        
        //Add action and category for actions to category
        let action = UNNotificationAction(identifier: "remindLater", title: "Remind me Later", options: [])
        let category = UNNotificationCategory(identifier: "reminderCategory", actions: [action], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func scheduleNotificationTime(_ date: Date) {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)
        let dateComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        
        //Trigger -> Set of conditions that must be met for a notification to deliver
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false) //In case of snooze, set it true
        
        //Create some content to display in our notification.
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Reminder"
        notificationContent.body = "Reminder text"
        notificationContent.sound = UNNotificationSound.default()
        notificationContent.categoryIdentifier = "reminderCategory"
        
        if let path = Bundle.main.path(forResource: "notificationLogo", ofType: "png") {
            
            let url = URL(fileURLWithPath: path)
            // The initializer for UNNotificationAttachment is marked as throwing, so we include a catch block to handle any errors.
            do {
                let attachment = try UNNotificationAttachment(identifier: "notificationLogo", url: url, options: nil)
                notificationContent.attachments  = [attachment]
            } catch {
                print("The attachment was not loaded.")
            }
        }
        
        
        //creating a notification request
        
        let notificationRequest = UNNotificationRequest(identifier: "textNotification", content: notificationContent, trigger: notificationTrigger)
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        //Add the request to the notification center that manages all notifications for your app
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if error != nil {
                print("Oops there is an error: \(error)")
            }
        }
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.actionIdentifier == "remindLater" {
            let newDate = Date(timeInterval: 900, since: Date()) //60 seconds * 15 minutes
            scheduleNotificationTime(newDate)
        }
    }
}

