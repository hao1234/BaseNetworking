//
//  NavigationController.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/2/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit

import UIKit

class NavigationController: UINavigationController {

    var shouldIgnorePusingViewControllers: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationStyle = .fullScreen
        let image = IMG.ic_nav_back_2.image?.withRenderingMode(.alwaysOriginal)
        navigationBar.backIndicatorImage = image
        navigationBar.backIndicatorTransitionMaskImage = image
        self.delegate = self
        modalPresentationStyle = .fullScreen
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.shouldIgnorePusingViewControllers {
            return
        }
        self.shouldIgnorePusingViewControllers = true
        super.pushViewController(viewController, animated: animated)
        // HACK: Workaround in iphone X, to fix tabbar jumps when a VC is pushed
        if var frame = tabBarController?.tabBar.frame {
            frame.origin.y = UIScreen.main.bounds.size.height - frame.size.height
            tabBarController?.tabBar.frame = frame
        }
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        let controller = super.popViewController(animated: animated)
        return controller
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension NavigationController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Hanlder for root in navigationcontroller with tap gesture
        if viewController === self.viewControllers.first {
            self.interactivePopGestureRecognizer?.isEnabled = false
            self.interactivePopGestureRecognizer?.delegate = nil
        }
        self.shouldIgnorePusingViewControllers = false
    }

}

// MARK: UIViewController
extension UIViewController {
    func embedInNavigationController() -> NavigationController {
        let nvc = NavigationController(navigationBarClass: NavigationBar.self, toolbarClass: nil)
        nvc.pushViewController(self, animated: false)
        return nvc
    }
}
