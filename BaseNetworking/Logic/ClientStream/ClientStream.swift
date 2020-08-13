//
//  ClientStream.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/2/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit
protocol ClientSessionDelegate: class {
    func clientSessionDidEnd(_ session: ClientSession)
}

final class ClientStream {
    public struct Dependencies {
        public let window: UIWindow
        public let uiFactory: UIFactoryProtocol
        public var launchOptions: [UIApplication.LaunchOptionsKey: Any]?

        public init(window: UIWindow,
                    uiFactory: UIFactoryProtocol,
                    launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {

            self.window = window
            self.uiFactory = uiFactory
            self.launchOptions = launchOptions
        }
    }
    
    static fileprivate(set) var sharedInstance: ClientStream!

    fileprivate(set) var session: ClientSession
    fileprivate let services: Services
    public var launchOptions: [UIApplication.LaunchOptionsKey: Any]?

    public static var session: ClientSession {
        return sharedInstance.session
    }

    public static func initialize(with dependencies: Dependencies) {
        if sharedInstance != nil {
            assertionFailure("ClientStream sharedInstance should be nil at initialization")
        }

        sharedInstance = ClientStream(dependencies: dependencies)
    }

    init(dependencies: Dependencies) {
        services = Services(window: dependencies.window,
                            uiFactory: dependencies.uiFactory)
        session = ClientSession(services: services)
        launchOptions = dependencies.launchOptions
        
        services.delegate = self
        session.delegate = self
    }
    
    fileprivate func startNewSession() {
        self.session = ClientSession(services: services)
        self.session.delegate = self
        self.session.start()
    }
}

// MARK: - ClientSessionDelegate
extension ClientStream: ClientSessionDelegate {
    func clientSessionDidEnd(_ session: ClientSession) {
        startNewSession()
    }
}

extension ClientStream: ServicesDelegate {
    func servicesDidChangeAppService() {
        startNewSession()
    }
}
