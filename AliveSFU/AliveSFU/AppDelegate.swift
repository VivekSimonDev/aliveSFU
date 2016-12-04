//
//  AppDelegate.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-10-26.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let flags = DataHandler.getFlags()
        
        if let isLogged = flags.isUserLoggedIn {
            if (isLogged) {
                //User is already logged in.
                if let userProfileExists = flags.profileExists {
                    if (userProfileExists) {
                        
                        //User profile exists, take user to main storyboard (Home page)
                        let sb = UIStoryboard(name: "Main", bundle: nil)
                        let vc = sb.instantiateInitialViewController()!
                        vc.modalPresentationStyle = .fullScreen
                        vc.modalTransitionStyle = .crossDissolve
                        
                        self.window = UIWindow.init(frame: UIScreen.main.bounds)
                        self.window?.rootViewController = vc
                        self.window?.makeKeyAndVisible()
                        
                    } else {
                        
                        //User profile doesn't exist. Take user to first time login
                        let sb = UIStoryboard(name: "firstTime", bundle: nil)
                        let vc = sb.instantiateInitialViewController()!
                        vc.modalPresentationStyle = .fullScreen
                        vc.modalTransitionStyle = .crossDissolve
                        
                        self.window = UIWindow.init(frame: UIScreen.main.bounds)
                        self.window?.rootViewController = vc
                        self.window?.makeKeyAndVisible()
                    }
                }
            } else {
                //User is not logged. Show login page
                let sb = UIStoryboard(name: "login", bundle: nil)
                let vc = sb.instantiateInitialViewController()!
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                
                self.window = UIWindow.init(frame: UIScreen.main.bounds)
                self.window?.rootViewController = vc
                self.window?.makeKeyAndVisible()
            }
        }
        return true
    }/*
    func application(application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }*/

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
}

