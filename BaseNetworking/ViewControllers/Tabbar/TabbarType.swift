//
//  TabbarType.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/2/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit

enum TabBarType: String, CaseIterable {
    case view1
    case view2
    case view3
    case view4
    
    var index: Int {
        return TabBarType.allCases.enumerated().first { $0.element == self }?.offset ?? 0
    }
    
    var tabbarItem: TabBarItem {
        switch self {
        case .view1:
            return TabBarItem(
                title: "Tab 1",
                image: IMG.tab_bar_ic_orders_default.image?.withRenderingMode(.alwaysOriginal),
                selectedImage: IMG.tab_bar_ic_orders_active.image?.withRenderingMode(.alwaysOriginal))
        case .view2:
            return TabBarItem(
                title: "Tab 2",
                image: IMG.tab_bar_ic_income_default.image?.withRenderingMode(.alwaysOriginal),
                selectedImage: IMG.tab_bar_ic_income_active.image?.withRenderingMode(.alwaysOriginal))
        case .view3:
            return TabBarItem(
                title: "Tab 3",
                image: IMG.tab_bar_ic_chat_default.image?.withRenderingMode(.alwaysOriginal),
                selectedImage: IMG.tab_bar_ic_chat_active.image?.withRenderingMode(.alwaysOriginal))
        case .view4:
            return TabBarItem(
                title: "Tab 4",
                image: IMG.tab_bar_ic_notification_default.image,
                selectedImage: IMG.tab_bar_ic_notification_active.image)
        }
    }
    
    func getRespresentVC() -> UIViewController {
        let nav: UINavigationController
        switch self {
        case .view1:
            let vc = ViewController1()
            nav = vc.embedInNavigationController()
        case .view2:
            let vc = ViewController2()
            nav = vc.embedInNavigationController()
        case .view3:
            let vc = ViewController3()
            nav = vc.embedInNavigationController()
        case .view4:
            let vc = ViewController4()
            nav = vc.embedInNavigationController()
        }
        nav.tabBarItem = self.tabbarItem
        return nav
    }
}
