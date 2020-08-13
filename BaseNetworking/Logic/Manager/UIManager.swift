//
//  UIManager.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/2/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit
import SwiftyLib

protocol Navigation {}

enum AppNavigation: Navigation {
}

enum TransitControllerType {
    case push
    case present
}

public protocol UIManagerEvents: class {
    func uiManagerDidShowMainScreen(_ manager: UIManager)
    func uiManagerDidShowLoginScreen(_ manager: UIManager)
    func uiManagerDidSplashScreen(_ manager: UIManager)
}

final public class UIManager: Multicastable {
    enum RootType {
        case login
        case main
        case splash
    }
    
    private let uiFactory: UIFactoryProtocol
    private let uiService: UIServiceProtocol
    
    public let multicast = Multicast<UIManagerEvents>()
    
    init(uiService: UIServiceProtocol,
         uiFactory: UIFactoryProtocol) {
        self.uiFactory = uiFactory
        self.uiService = uiService
    }
    
    func resetRootViewController(type: RootType) {
        let vc: UIViewController
        switch type {
        case .splash:
            vc = uiFactory.splashViewController()
            self.multicast.invokeMain({ [weak self] in
                guard let me = self else { return }
                $0.uiManagerDidSplashScreen(me)
            })
        case .login:
            vc = uiFactory.rootLoginViewController()
            self.multicast.invokeMain({ [weak self] in
                guard let me = self else { return }
                $0.uiManagerDidShowLoginScreen(me)
            })
        case .main:
            vc = uiFactory.rootMainViewController()
            self.multicast.invokeMain({ [weak self] in
                guard let me = self else { return }
                $0.uiManagerDidShowMainScreen(me)
            })
        }
        
        uiService.replaceRootViewController(vc)
    }
    
    public func present(viewController: UIViewController, animated: Bool, completion: EmptyBlock?) {
        uiService.present(viewController: viewController, animated: animated, completion: completion)
    }
    
    func showOnTop(viewController: UIViewController, completion: EmptyBlock?) {
        uiService.showOnTop(viewController: viewController, completion: completion)
    }
    
    func dismissOnTop(viewController: UIViewController, completion: EmptyBlock?) {
        uiService.dismissOnTop(viewController: viewController, completion: completion)
    }
    
    @discardableResult func pushNavigationController(
        viewController: UIViewController,
        animated: Bool,
        completion: EmptyBlock? = nil
    ) -> Bool {
        uiService.pushNavigationController(
            viewController: viewController,
            animated: animated,
            completion: completion)
    }
    
    @discardableResult
    func popNavigationController(animated: Bool) -> Bool {
        return uiService.popNavigationController(animated:animated)
    }
    
    func openControllerPath(_ path: RouterPath, completion: EmptyBlock? = nil) {
        dispatch_async_main_queue {
            self.uiService.openControllerPath(path, completion: completion)
        }
    }
}
