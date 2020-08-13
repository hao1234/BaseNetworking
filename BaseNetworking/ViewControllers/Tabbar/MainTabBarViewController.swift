//
//  MainTabBarViewController.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/2/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = false
        tabBar.tintColor = Theme.current.styleguide.tabarSelected
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func openControllerPath(_ path: RouterPath) {

    }
}
