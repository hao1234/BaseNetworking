//
//  Theme.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/2/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import Foundation
import UIKit

protocol ThemeProtocol {
    var sizeType: Theme.SizeType {get}
    var styleguide: StyleguideProtocol { get }

    var primaryHighlightActionButtonColor: UIColor {get}
}

class Theme {
    enum FontType {
        case light
        case normal
        case medium
        case semiBold
        case bold
        case italic
        case boldItalic
        case black
    }

    enum SizeType: Int, CaseIterable {

        case verySmall
        case small
        case normal
        case large
        case veryLarge

        var ratio: CGFloat {
            switch self {
            case .verySmall:
                return 0.8
            case .small:
                return 0.9
            case .normal:
                return 1.0
            case .large:
                return 1.1
            case .veryLarge:
                return 1.2
            }
        }
    }
    static let themeDidChangeNotificationName: Notification.Name = Notification.Name("kThemeDidChangeNotificationName")

    static let borderWidth: CGFloat = ceil(1) / UIScreen.main.scale
    static var sizeType: SizeType = {
        /* User select type, get last option to create theme
        if let sizeTypeRaw = UserDefaults.standard.object(forKey: SettingKeys.UserDefaultKey.themeSizeType) as? Int,
            let sizeType = SizeType(rawValue: sizeTypeRaw)
        {
            return sizeType
        }

        UserDefaults.standard.set(SizeType.normal.rawValue, forKey: SettingKeys.UserDefaultKey.themeSizeType)
        */
        return .normal
    }()

    static fileprivate(set) var current: ThemeProtocol = DefaultTheme(sizeType: sizeType)

    static func setSizeType(_ sizeType: SizeType) {
        /* User select type, store user defaut for later
        UserDefaults.standard.set(sizeType.rawValue, forKey: SettingKeys.UserDefaultKey.themeSizeType)
        */
        NotificationCenter.default.post(name: self.themeDidChangeNotificationName, object: nil)
        self.sizeType = sizeType
        self.current = DefaultTheme(sizeType: sizeType)
    }
}

class DefaultTheme: ThemeProtocol {

    let sizeType: Theme.SizeType

    init(sizeType: Theme.SizeType) {
        self.sizeType = sizeType
    }

    lazy var styleguide: StyleguideProtocol = StyleguideTheme()
    
    var primaryHighlightActionButtonColor: UIColor {
        return styleguide.primaryHighlightActionButtonColor
    }
}

