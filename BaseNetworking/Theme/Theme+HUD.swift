//
//  Theme+HUD.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/5/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit

extension ThemeProtocol {
    
    var hudLoadingBackgroundColor: UIColor {
        return UIColor(hex: "4F5664", alpha: 0.7)
    }
    
    var hudBackgroundColor: UIColor {
        return .white
    }
    var hudShadowColor: UIColor {
        return .black
    }
    
    var hudTextColor: UIColor {
        return primaryTextColor
    }
    
    var hudSuccessImage: UIImage? {
        return nil
    }
    var hudWarningImage: UIImage? {
        return nil
    }
    var hudErrorImage: UIImage? {
        return nil
    }
    
    var hudLoadingLogoImage: UIImage? {
        return nil
    }
}
