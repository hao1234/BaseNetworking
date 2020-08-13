//
//  UIFactory.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/2/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import Foundation
import UIKit

protocol UIFactoryProtocol {
    func rootLoginViewController() -> UIViewController
    func rootMainViewController() -> UIViewController
    func splashViewController() -> UIViewController
}

final class UIFactory: NSObject, UIFactoryProtocol {
    static let sharedInstance = UIFactory()
    private override init(){}
    
    func rootLoginViewController() -> UIViewController {
        let vc = ExampleTableViewController(viewModel: ViewModel())
        let nvc = NavigationController(
            navigationBarClass: NavigationBar.self,
            toolbarClass: nil)
        nvc.pushViewController(vc, animated: false)
        return nvc
    }
    
    func rootMainViewController() -> UIViewController {
        let tabBarVC = MainTabBarViewController()
        tabBarVC.delegate = self
        tabBarVC.viewControllers = TabBarType.allCases.map {
            let viewController = $0.getRespresentVC()
            return viewController
        }
        return tabBarVC
    }
    
    func splashViewController() -> UIViewController {
        return BaseViewController(viewModel: ViewModel())
    }
}

extension UIFactory: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    }
}

