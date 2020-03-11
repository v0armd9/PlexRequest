//
//  AppDelegate.swift
//  Plex Request
//
//  Created by Darin Armstrong on 8/23/19.
//  Copyright © 2019 Darin Armstrong. All rights reserved.
//

import UIKit
import UserNotifications
import CloudKit
import NotificationCenter

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UITabBar.appearance().tintColor = UIColor.systemYellow
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge,. sound]) { (userDidAllow, error) in
            if let error = error {
            print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
        }
            if userDidAllow {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//         subscribe to remote notifications for newly requested movies
        MovieController.sharedInstance.subscribeForAddedMovieRemoteNotifications { (error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
            }
            MovieController.sharedInstance.subscribeForEditedMovieRemoteNotifications { (error) in
                if let error = error {
                    print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                }
                TVShowController.sharedInstance.subscribeForAddedShowRemoteNotifications { (error) in
                    if let error = error {
                        print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                    }
                    TVShowController.sharedInstance.subscribeForEditedShowRemoteNotifications { (error) in
                        if let error = error {
                            print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                        }
                    }
                }
            }
        }
    }

    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        MovieController.sharedInstance.fetchRequestedMovies { (results) in
            //TODO
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        MovieController.sharedInstance.resetBadgeCounter()
        }
}

