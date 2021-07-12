//
//  AppDelegate.swift
//  Freshi
//
//  Created by Jinwook Huh on 2021/07/04.
//

import UIKit
import UserNotifications

let initialLaunchKey = "initialLaunchKey"
let notificicationEnabledKey = "notificicationEnabledKey"


let notificationIdentifier = "dailyNotification"



@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        DataManager.shared.setup(modelName: "DataModel")
        
        UNUserNotificationCenter.current().requestAuthorization(options: [UNAuthorizationOptions.alert, UNAuthorizationOptions.sound]) { granted, error in
            if granted {
                UNUserNotificationCenter.current().delegate = self
            }
        }
        
        if !UserDefaults.standard.bool(forKey: initialLaunchKey) {
            
            
            // set notification
            var dateComponents = DateComponents()
            dateComponents.hour = 19
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let content = UNMutableNotificationContent()
            content.title = "냉장고 확인"
            content.body = "냉장고 음식들의 유통기한을 확인하세요!"
            
            let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                print("Error in adding notification")
            }
            
            
            UserDefaults.standard.set(true, forKey: initialLaunchKey)
            UserDefaults.standard.set(true, forKey: notificicationEnabledKey)
        }
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
}

