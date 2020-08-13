//
//  BarButtonItem.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/9/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit

class BarButtonItem: UIBarButtonItem {
    override init() {
        super.init()

        let normalAttribs = [NSAttributedString.Key.foregroundColor: Theme.current.defaultBarButtonItemColor,
                       NSAttributedString.Key.font: Theme.current.font(.medium, size: 14)]
        setTitleTextAttributes(normalAttribs, for: .normal)

        let disableAttribs = [NSAttributedString.Key.foregroundColor: Theme.current.defaultBarButtonItemColor.withAlphaComponent(0.6),
                             NSAttributedString.Key.font: Theme.current.font(.medium, size: 14)]
        setTitleTextAttributes(disableAttribs, for: .disabled)

        let selectedAttribs = [NSAttributedString.Key.foregroundColor: Theme.current.defaultBarButtonItemColor.withAlphaComponent(0.6),
                              NSAttributedString.Key.font: Theme.current.font(.medium, size: 14)]
        setTitleTextAttributes(selectedAttribs, for: .highlighted)
        tintColor = Theme.current.defaultBarButtonItemColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

