//
//  AppDelegate.swift
//  challengeParticulas
//
//  Created by Luis Eduardo Boiko Ferreira on 21/08/17.
//  Copyright © 2017 Luis Eduardo Boiko Ferreira. All rights reserved.
//

import UIKit
import GameController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var motionDelegate: ReactToMotionEvents? = nil
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let center = NotificationCenter.default
        
        center.addObserver(forName: .GCControllerDidConnect, object: nil, queue: .main) { (notification) in
            if let controller = notification.object as? GCController {
                print("controller connected (\(controller.vendorName!))")
                controller.motion?.valueChangedHandler = { motion in
                    if let delegate = self.motionDelegate {
                        delegate.motionUpdate(motion: motion)
                    }
                }
            }
        }
        
        GCController.startWirelessControllerDiscovery()
        
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
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
}

protocol ReactToMotionEvents {
    func motionUpdate(motion: GCMotion) -> Void
}
