//
//  AppDelegate.swift
//  TwitterRedux
//
//  Created by bis on 4/20/17.
//  Copyright © 2017 biswa. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if User.currentUser == nil {
            print("Guest user")
            let client = TwitterClient.sharedInstance
            client.login(success: { (user: User) in
                User.currentUser = user
                print("login success..")
                self.showHamburgerViewController()
            }) { (error: Error?) in
                let errorText = error?.localizedDescription ?? "unknow error"
                print("Error: \(errorText)")
            }

        } else {
            print("Logged-in user")
            showHamburgerViewController()
        }
        return true
    }
    
    func showHamburgerViewController() {
        let hamburgerMenuViewController = window!.rootViewController as! HamburgerViewController
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let menuViewController = storyBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        hamburgerMenuViewController.menuViewController = menuViewController
        menuViewController.hamburgerMenuViewController = hamburgerMenuViewController
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
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        TwitterClient.sharedInstance.handleOpenURL(url: url)
        return true
    }

}

