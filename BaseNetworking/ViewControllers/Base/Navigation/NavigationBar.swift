//
//  NavigationBar.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/2/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit

class NavigationBar: UINavigationBar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setBackgroundImage(Theme.current.navigationBarBackgroundImage, for: .default)
        titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Theme.current.navigationBarTitleColor,
            NSAttributedString.Key.font: Theme.current.font(.medium, size: 16)
        ]
        self.isTranslucent = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

