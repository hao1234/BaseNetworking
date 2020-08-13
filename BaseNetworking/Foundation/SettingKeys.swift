//
//  SettingKeys.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/6/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit

extension Notification.Name {
    public static let LanguageDidChanged = Notification.Name("LanguageDidChanged")
}

struct SettingKeys {
    // Request API timeout
    public static var timeoutRequest: TimeInterval {
        return 20
    }
    
    // Loading timeout
    public static var timeoutLoading: TimeInterval {
        return 30
    }
}
