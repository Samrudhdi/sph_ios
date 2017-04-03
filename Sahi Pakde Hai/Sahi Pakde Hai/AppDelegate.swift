//
//  AppDelegate.swift
//  Sahi Pakde Hai
//
//  Created by Dipti Fulwani on 24/06/16.
//  Copyright © 2016 Patronous Inc. All rights reserved.
//

import UIKit
import FacebookCore
import Fabric
import Crashlytics
import Mixpanel

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Fabric initialization
        Fabric.with([Crashlytics.self])
        
        setupMixpanel()
        
        // Google analytics
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        guard let gai = GAI.sharedInstance() else {
            assert(false, "Google Analytics not configured correctly")
            return true
        }
        gai.trackUncaughtExceptions = true  // report uncaught exceptions
        gai.logger.logLevel = GAILogLevel.verbose  // remove before app release

        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return SDKApplicationDelegate.shared.application(application,
                                                         open: url,
                                                         sourceApplication: sourceApplication,
                                                         annotation: annotation)
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return SDKApplicationDelegate.shared.application(application, open: url, options: options)
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
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let mixpanel = Mixpanel.mainInstance()
        print("device token: \(deviceToken)")
        mixpanel.people.addPushDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugPrint(error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        debugPrint("did receive remote notification")
        if let message = (userInfo["aps"] as? [String: Any])?["alert"] as? String {
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            window?.rootViewController?.present(alert, animated: true, completion: nil)
            
        }
        
        Mixpanel.mainInstance().trackPushNotification(userInfo)
     }
    
    
//    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//    
//        if self.window?.rootViewController?.presentingViewController is PlayGameViewController {
//            return UIInterfaceOrientationMask.landscapeLeft
//        }else {
//            return UIInterfaceOrientationMask.portrait
//        }
//    }

    func setupMixpanel() {
        
        // Mixpanel Initializer
        Mixpanel.initialize(token: Constant.MIXPANEL_TOKEN)
        Mixpanel.mainInstance().loggingEnabled = true
        Mixpanel.mainInstance().flushInterval = 5
        
        let setting = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(setting)
        UIApplication.shared.registerForRemoteNotifications()
        
        Mixpanel.mainInstance().identify(distinctId: Mixpanel.mainInstance().distinctId)
        

    }

}


