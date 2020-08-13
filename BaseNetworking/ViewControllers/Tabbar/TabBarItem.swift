//
//  TabBarItem.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/2/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit

class TabBarItem: UITabBarItem {
    override init() {
        super.init()

        imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: -2, right: 0)
        setTitleTextAttributes([.foregroundColor: Theme.current.styleguide.tabarSelected],
                               for: .selected)
        titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
