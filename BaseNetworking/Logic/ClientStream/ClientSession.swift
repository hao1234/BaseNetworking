//
//  ClientSession.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/2/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit

final class ClientSession {
    weak var delegate: ClientSessionDelegate?
    let services: Services
    private let webProvider: AppWebProvider
    
    private(set) var managerUI: UIManager
    private(set) var managerInterruption: InterruptionManager
    private(set) var demoManager: DemoWebManager
    
    init(services: Services) {
        self.services = services
        managerInterruption = InterruptionManager()
        
        managerUI = UIManager(
            uiService: services.ui,
            uiFactory: services.uiFactory)
        
        webProvider = AppWebProvider(
            webService: services.web,
            baseAddress: "https://api.unsplash.com",
            appService: services.app,
            authService: services.authen,
            interruption: managerInterruption)
        demoManager = DemoWebManager(webProvider: webProvider)
        
        Language.sharedInstance.subscribeEvents(self)
    }
    
    deinit {
        Logger.info("session deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    func start() {
        Logger.info("session start")
        refreshRootViewController()
    }
    
    func end() {
        // TODO: clear all data if need
        delegate?.clientSessionDidEnd(self)
    }
    
    func refreshRootViewController() {
        Logger.info("refreshRootViewController")
        
        let rootType: UIManager.RootType = .splash
        // TODO: check token if have -> main, ifnot -> splash or login
        Logger.info("rootType: \(rootType)")
        managerUI.resetRootViewController(type: rootType)
    }
    
    func startMainScreenViewController() {
        managerUI.resetRootViewController(type: .login)
    }
}

extension ClientSession: LanguageEvents {
    func languageDidChanged() {
        startMainScreenViewController()
    }
}
