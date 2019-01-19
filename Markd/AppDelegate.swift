//
//  AppDelegate.swift
//  Markd
//
//  Created by Joshua Daniel Schmidt on 12/3/16.
//  Copyright © 2016 Joshua Daniel Schmidt. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    override init() {
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        registerForPushNotifications(application)
        
        if let notification = launchOptions?[.remoteNotification] as? [String: AnyObject],
            let _ = notification["aps"] as? [String: AnyObject] {
            //TODO: Make this work and/or set badge value
            //window?.rootViewController?.tabBarController?.selectedIndex = 3
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        application.applicationIconBadgeNumber = 0
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
        ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        //HERE you would send to firebase server to store
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    //Notification while app is in foreground
    func application(_ application: UIApplication,didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard let _ = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
        }
        //TODO: Make this work and/or set badge value
        //window?.rootViewController?.tabBarController?.selectedIndex = 3
    }

    func registerForPushNotifications(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current() // 1
                .requestAuthorization(options: [.alert, .sound, .badge]) {
                    [weak self] granted, error in
                    
                    print("Permission granted: \(granted)")
                    guard granted else { return }
                    self?.getNotificationSettings(application)
            }
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            
            application.registerUserNotificationSettings(settings)
            self.getNotificationSettings(application)
        }
    }
    func getNotificationSettings(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                print("Notification settings: \(settings)")
                guard settings.authorizationStatus == .authorized else { return }
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
}

