//
//  AppDelegate.swift
//  SinchCalling_Swift
//
//  Created by Yogish on 19/01/16.
//  Copyright © 2016 TnE. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SINClientDelegate {

    var window: UIWindow?
    var client: SINClient? = nil

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        if launchOptions != nil {
            let launchOptionsDict = launchOptions! as NSDictionary
            self.handleNotification(launchOptionsDict.objectForKey(UIApplicationLaunchOptionsLocalNotificationKey) as? UILocalNotification)
        }
        
        self.requestUserNotificationPermission()
        
        NSNotificationCenter.defaultCenter().addObserverForName("UserDidLoginNotification", object: nil, queue: nil) { (notification: NSNotification) -> Void in
            self.initSinchClientWithUserId(notification.userInfo!["userId"] as! String)
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        self.handleNotification(notification)
    }
    
    func requestUserNotificationPermission() {
        if UIApplication.sharedApplication().respondsToSelector("registerUserNotificationSettings") {
            let types: UIUserNotificationType = [.Alert, .Sound]
            let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        }
    }

    // MARK: - Sinch Client Initializer
    
    func initSinchClientWithUserId(userId: String) {
        guard (client != nil) else {
            
            client = Sinch.clientWithApplicationKey("Your Application Key Here", applicationSecret: "Your Application Secret Here", environmentHost: "sandbox.sinch.com", userId: userId)
            
            client?.delegate = self
            client?.setSupportCalling(true)
            client?.setSupportActiveConnectionInBackground(true)
            client?.start()
            client?.startListeningOnActiveConnection()
            
            return
        }
    }
    
    func handleNotification(notification: UILocalNotification?) {
        
        if notification != nil {
           
            let result: SINNotificationResult = (self.client?.relayLocalNotification(notification))!
            
            if result.isCall() && result.callResult().isTimedOut {
                let alert: UIAlertController = UIAlertController(title: "Missed Call", message: String(format: "Missed Call from %@", arguments: [result.callResult().remoteUserId]), preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "Ok", style: .Default, handler: {_ -> Void in
                    alert.dismissViewControllerAnimated(true, completion: nil)
                } )
                
                alert.addAction(okAction)
                
                self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - SINClientDelegate
    
    func clientDidStart(client: SINClient!) {
        print("Sinch Client Started Successfully. (Version: \(Sinch.version())")
    }
    
    func clientDidFail(client: SINClient!, error: NSError!) {
        print("Sinch Client Error: \(error.localizedDescription)")
    }
    
    func client(client: SINClient!, logMessage message: String!, area: String!, severity: SINLogSeverity, timestamp: NSDate!) {
        if severity == .Critical {
            print(message)
        }
    }
    
}

