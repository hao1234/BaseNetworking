//
//  Services.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/2/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit
import MLWebService

protocol ServicesDelegate: class {
    func servicesDidChangeAppService()
}

final public class Services {
    let notificationCenter: NotificationCenter
    let userDefaults: UserDefaults

    let uiFactory: UIFactoryProtocol
    let ui: UIServiceProtocol
    let app: AppService
    let web: WebServiceProtocol
    let authen: AuthServiceProtocol
    
    var delegate: ServicesDelegate?

    init(window: UIWindow, uiFactory: UIFactoryProtocol) {
        notificationCenter = NotificationCenter.default
        userDefaults = UserDefaults.standard

        self.uiFactory = uiFactory
        ui = UIService(window: window)
        app = AppService.shared
        web = AppWebService()
        
        AuthService.initialize()
        authen = AuthService.shared
    }
}

extension Services: AppServiceDelegate {
    public func appServiceDidChange(_ app: AppService) {
        delegate?.servicesDidChangeAppService()
    }
}
