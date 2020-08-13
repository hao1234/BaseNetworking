//
//  UINavigationController+Extension.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/2/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit

extension UINavigationController {
    func popViewControllerWithHandler(poptoRoot: Bool = true, animated: Bool, completion: EmptyBlock?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        if poptoRoot {
            popToRootViewController(animated: animated)
        } else {
            popViewController(animated: animated)
        }
        CATransaction.commit()
    }
    
    func popToViewControllerWithHandler(vc: UIViewController, animated: Bool, completion: EmptyBlock?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popToViewController(vc, animated: animated)
        CATransaction.commit()
    }
    
    func push(viewController: UIViewController, animated: Bool, completion: EmptyBlock?) {
        guard let completion = completion else {
            pushViewController(viewController, animated: animated)
            return
        }
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
}
