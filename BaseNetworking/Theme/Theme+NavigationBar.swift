//
//  Theme+NavigationBar.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/2/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit

extension ThemeProtocol {
    var navigationBarBackgroundImage: UIImage? {
        return navigationBarBackgroundColor.image()
    }
    
    var navigationBarBackgroundColor: UIColor {
        return .red// UIColor(red: 37.0/255, green: 39.0/255, blue: 49.0/255, alpha: 1)
    }
    
    var navigationBarButtonBackImage: UIImage? {
        return IMG.ic_nav_back_2.image
    }
    
    var navigationBarTitleColor: UIColor {
        return .white
    }
    
    var navigationHeaderHeight: CGFloat {
        return 44.0
    }
}
