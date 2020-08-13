//
//  UIViewController+Extension.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/5/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit
import SwiftyLib

extension UIViewController {
    
    func frontmostPresentedViewController() -> UIViewController {
        
        var vc = self
        
        while let presentedVC = vc.presentedViewController {
            vc = presentedVC
        }
        
        return vc
    }
    
    func getFrontmostPresentedLoadedViewController(vcHandler: SingleParamBlock<UIViewController?>?) -> RetryAction {
        var isCalledInvalidBlock = false // prevent called invalid block twice
        let retryAction = RetryAction.create(
            type: .interval(interval: 0.2, numberOfMaxRetry: 5),
            actionBlock: { [weak self] retryAction in
                guard let self = self else {
                    vcHandler?(nil)
                    return
                }
                let frontVC = self.frontmostPresentedViewController()
                let isCalledDismiss: Bool
                if let vc = frontVC as? BaseViewController {
                    isCalledDismiss = vc.isCalledDismiss
                } else {
                    isCalledDismiss = false
                }
                if frontVC.viewIfLoaded?.window != nil && isCalledDismiss == false { // check if view in front vc is loaded
                    isCalledInvalidBlock = true
                    vcHandler?(frontVC)
                } else {
                    retryAction.retry() // wait to front vc loaded
                }
        }) { _,_ in
            guard isCalledInvalidBlock == false else { return }
            isCalledInvalidBlock = true
            vcHandler?(nil)
        }
        
        retryAction.start()
        return retryAction
    }
}

// MARK: - Parent VC

extension UIViewController {
    
    func findParentViewController<T>() -> T? {
        
        var specifiedVC: T?
        var vc: UIViewController = self
        
        while (specifiedVC == nil) && (vc.parent != nil) {
            vc = vc.parent!
            specifiedVC = vc as? T ?? nil
        }
        
        return specifiedVC
    }
    
    func rootParentViewController() -> UIViewController? {
        
        var parentVC = parent
        
        while let vc = parentVC?.parent {
            parentVC = vc
        }
        
        return parentVC
    }
}
