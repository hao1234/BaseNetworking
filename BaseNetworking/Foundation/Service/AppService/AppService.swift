//
//  AppService.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/5/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit
import SwiftyLib

public protocol AppServiceDelegate: class {
    func appServiceDidChange(_ app: AppService)
}

public protocol AppServiceEvents {

    func appNeedToRefreshData()

    func applicationDidEnterBackground()

    func applicationWillEnterForeground()

}

extension AppServiceEvents {

    func appNeedToRefreshData() {}

    func applicationDidEnterBackground() {}

    func applicationWillEnterForeground() {}
}

public class AppService: Multicastable {

    public static fileprivate(set) var shared: AppService = AppService()
    public var multicast = Multicast<AppServiceEvents>()
    public weak var delegate: AppServiceDelegate?
    
    private init() {
        #if RELEASE
            environmentType = .release  
        #elseif INTRELEASE
            environmentType = .intrelease
        #else
            environmentType = .debug
        #endif
        self.environment = AppEnvironment(self.environmentType)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.applicationDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.applicationWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func applicationDidEnterBackground() {
        Logger.logCrashlytics(string: "applicationDidEnterBackground")
        multicast.invokeMain {
            $0.applicationDidEnterBackground()
        }
    }

    @objc func applicationWillEnterForeground() {
        Logger.logCrashlytics(string: "applicationWillEnterForeground")

        multicast.invokeMain {
            $0.applicationWillEnterForeground()
        }
    }
    
    var clientID: String {
        UUID().uuidString
    }

    /// Get os version
    var osVersion: String {
        get {
            return UIDevice.current.systemVersion
        }
    }

    /// Get os name
    var deviceUserName: String {
        return UIDevice.current.name
    }

    var appVersion: String {
        return (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
    }

    var buildVersionNumber: String {
        return (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? ""
    }

    var appName: String {
        return (Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String) ?? ""
    }

    var appBundleID: String {
        return Bundle.main.bundleIdentifier ?? ""
    }
    
    var environmentType: AppEnvironmentType {
        willSet {
            #if RELEASE
                // Just only accpet release env if somewhere set other value in envType
                if newValue != .release {
                    self.environmentType = .release
                    self.environment = AppEnvironment(newValue)
                }
            #elseif INTRELEASE
                if newValue != .intrelease {
                    self.environmentType = .intrelease
                    self.environment = AppEnvironment(newValue)
                }
            #else
                // Should store enviroment if app allow chose multi target
                self.environment = AppEnvironment(newValue)
            #endif
        }
        didSet {
            self.delegate?.appServiceDidChange(self)
        }
    }
    
    fileprivate(set) var environment: AppEnvironment
}
