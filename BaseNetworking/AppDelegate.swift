//
//  AppDelegate.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/2/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit
import SDWebImage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let dependencies = ClientStream.Dependencies(
            window: self.window!,
            uiFactory: UIFactory.sharedInstance,
            launchOptions: launchOptions
        )
        SDImageCache.shared().config.maxCacheAge = 7*24*60*60 // 7 days
        SDImageCache.shared().config.maxCacheSize = 30*1024*1024 // 30 MBs
        
        Logger.initialize()
        ClientStream.initialize(with: dependencies)
        ClientStream.session.startMainScreenViewController()
        
        return true
    }

}

