//
//  AppDelegate.swift
//  Sprite Kit Breakout
//
//  Created by Jacob Davis on 7/6/16.
//  Copyright © 2016 Jacob Davis. All rights reserved.
//

import UIKit
import SpriteKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

        guard let rootViewController = self.window?.rootViewController as? GameViewController else {
            return
        }
        
        guard let view = rootViewController.view as? SKView else {
            return
        }
        
        view.isPaused = true
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

        guard let rootViewController = self.window?.rootViewController as? GameViewController else {
            return
        }
        
        guard let view = rootViewController.view as? SKView else {
            return
        }

        view.isPaused = false
        
    }

    func applicationWillTerminate(_ application: UIApplication) {

    }

}
