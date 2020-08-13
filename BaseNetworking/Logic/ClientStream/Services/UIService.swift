//
//  UIService.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/2/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit
import SwiftyLib

protocol UIServiceProtocol {
    func replaceRootViewController(_ viewController: UIViewController)
    func present(viewController: UIViewController, animated: Bool, completion: EmptyBlock?)
    func dismiss(viewController: UIViewController, animated: Bool, completion: EmptyBlock?)
    func pushNavigationController(
        viewController: UIViewController,
        animated: Bool,
        completion: EmptyBlock?) -> Bool
    func popNavigationController(animated: Bool) -> Bool
    func openControllerPath(_ path: RouterPath, completion: EmptyBlock?)
    func showOnTop(viewController: UIViewController, completion: EmptyBlock?)
    func dismissOnTop(viewController: UIViewController, completion: EmptyBlock?)
}

private final class PresentItem {
    
    let vc: UIViewController
    var completion: EmptyBlock?
    var retryAction: RetryAction?
    let createdTime: Date
    init(vc: UIViewController, completion: EmptyBlock?) {
        self.vc = vc
        self.completion = completion
        self.createdTime = Date()
    }
}

extension PresentItem: Equatable {
    static func == (lhs: PresentItem, rhs: PresentItem) -> Bool {
        return lhs.vc == rhs.vc
    }
}

class UIService: UIServiceProtocol {
    
    private let presentTimeOut = 3.0 // timeout for present a viewcontroller
    private let window: UIWindow
    private var presentViewControllerQueue: [PresentItem] = []
    
    init(window: UIWindow) {
        self.window = window
        self.styleTabBarAppearance()
    }
    
    func replaceRootViewController(_ viewController: UIViewController) {
        if let rootViewController = window.rootViewController {
            // Replacing rootVC does not dismiss any presented VC causing weird UI and leak
            rootViewController.dismiss(animated: false, completion: nil)
            
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = CATransitionType.fade
            transition.subtype = CATransitionSubtype.fromBottom
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            window.layer.add(transition, forKey: kCATransition)
        }
        
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
    
    private func singlePresent(animated: Bool) {
        guard let rootViewController = window.rootViewController,
            let firstPresentItem = presentViewControllerQueue.first else {
                assertionFailure()
                return
        }
        firstPresentItem.retryAction = rootViewController.getFrontmostPresentedLoadedViewController
            { [weak self, weak firstPresentItem] frontVC in
                guard let self = self,
                    let firstPresentItem = firstPresentItem
                    else { return }
                guard let frontVC = frontVC else {
                    if let index = self.presentViewControllerQueue.firstIndex(where: { $0 == firstPresentItem }) {
                        self.presentViewControllerQueue.remove(at: index) // if can not find front VC so remove item to not block the queue
                    }
                    if self.presentViewControllerQueue.isEmpty == false {
                        self.singlePresent(animated: true)
                    } // after remove error item, present other item in queue
                    return
                }
                frontVC.present(
                    firstPresentItem.vc,
                    animated: animated,
                    completion: { [weak self] in
                        firstPresentItem.completion?()
                        guard let self = self,
                            let index = self.presentViewControllerQueue.firstIndex(where: { $0 == firstPresentItem }) else {
                                return
                        }
                        self.presentViewControllerQueue.remove(at: index)
                        if self.presentViewControllerQueue.isEmpty == false {
                            self.singlePresent(animated: true)
                        }
                })
        }
    }
    
    func showOnTop(viewController: UIViewController, completion: EmptyBlock?) {
        guard let rootViewController = window.rootViewController else {
            assertionFailure(); return
        }
        window.addSubview(viewController.view)
        window.bringSubviewToFront(viewController.view)
        rootViewController.addChild(viewController)
        viewController.didMove(toParent: rootViewController)
        viewController.view.alpha = 0
        viewController.view.frame = CGRect(x: 0, y: 0, width:window.frame.size.width, height: window.frame.size.height)
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
        UIView.transition(
            with: viewController.view,
            duration: 0.25,
            options: [.curveEaseInOut, .allowUserInteraction],
            animations: {
                viewController.view.alpha = 1
        }, completion: { result in
            viewController.view.alpha = 1
            completion?()
        })
    }
    
    func dismissOnTop(viewController: UIViewController, completion: EmptyBlock?) {
        UIView.transition(
            with: window,
            duration: 0.25,
            options: [.curveEaseInOut, .allowUserInteraction],
            animations: {
                viewController.view.alpha = 0
        }, completion: { _ in
            viewController.view.removeFromSuperview()
            viewController.removeFromParent()
            completion?()
        })
    }
    
    func present(viewController: UIViewController, animated: Bool, completion: EmptyBlock?) {
        presentViewControllerQueue.append(PresentItem(vc: viewController, completion: completion))
        if presentViewControllerQueue.count == 1 {
            singlePresent(animated: true) // just execute present if no viewcontroller in queue
        } else if let processingItem = presentViewControllerQueue.first,
            Date().timeIntervalSince1970 - processingItem.createdTime.timeIntervalSince1970 > presentTimeOut  {
            presentViewControllerQueue.removeFirst()
            singlePresent(animated: true) // if processing vc present too long, remove it from queue
        }
    }
    func dismiss(viewController: UIViewController, animated: Bool, completion: EmptyBlock?) {
        viewController.dismiss(animated: animated, completion: completion)
    }
    
    func pushNavigationController(
        viewController: UIViewController,
        animated: Bool,
        completion: EmptyBlock?
    ) -> Bool {
        guard let rootViewController = window.rootViewController else {
            assertionFailure(); return false
        }
        
        if let rootViewController = rootViewController as? UINavigationController {
            rootViewController.push(
                viewController: viewController,
                animated: animated,
                completion: completion)
            return true
        }
        
        if let rootViewController = rootViewController.navigationController {
            rootViewController.push(
                viewController: viewController,
                animated: animated,
                completion: completion)
            return true
        }
        
        if let rootViewController = rootViewController as? UITabBarController {
            if let navVC =  rootViewController.selectedViewController as? UINavigationController {
                navVC.push(
                    viewController: viewController,
                    animated: animated,
                    completion: completion)
                return true
            }
            
            if let navVC =  rootViewController.selectedViewController?.navigationController {
                navVC.push(
                    viewController: viewController,
                    animated: animated,
                    completion: completion)
                return true
            }
        }
        
        return false
    }
    
    func popNavigationController(animated: Bool) -> Bool {
        guard let rootViewController = window.rootViewController else {
            assertionFailure(); return false
        }
        
        if let rootViewController = rootViewController as? UINavigationController {
            rootViewController.popViewController(animated: animated)
            return true
        }
        
        if let rootViewController = rootViewController.navigationController {
            rootViewController.popViewController(animated: animated)
            return true
        }
        
        if let rootViewController = rootViewController as? UITabBarController {
            if let navVC =  rootViewController.selectedViewController as? UINavigationController {
                navVC.popViewController(animated: animated)
                return true
            }
            
            if let navVC =  rootViewController.selectedViewController?.navigationController {
                navVC.popViewController(animated: animated)
                return true
            }
        }
        
        return false
    }
    
    func openControllerPath(_ path: RouterPath, completion: EmptyBlock?) {
        defer {
            completion?()
        }
        guard let rootViewController = window.rootViewController else {
            assertionFailure();
            return
        }
        
        Logger.logCrashlytics(string: "Open router path \(path.path)")
        if let rootViewController = rootViewController as? MainTabBarViewController {
            rootViewController.openControllerPath(path)
            return
        }
    }
}

// MARK: UIAppearance
extension UIService {
    func styleTabBarAppearance() {
        UITabBar.appearance().tintColor = UIColor.clear
        UITabBar.appearance().barTintColor = UIColor.white
    }
}
