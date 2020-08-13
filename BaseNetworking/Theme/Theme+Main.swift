//
//  Theme+Main.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/2/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit

let rateReduceHeight: CGFloat = UIDevice.current.isUnderIphone6ScreenSize
    ? 0.85
    : 1.0

extension ThemeProtocol {
    func font(_ type: Theme.FontType, size: CGFloat, isReduceByScreen: Bool = false, traits: UIFontDescriptor.SymbolicTraits? = nil) -> UIFont {
        var size = size * self.sizeType.ratio
        if isReduceByScreen {
            size *= rateReduceHeight
        }
        
        let font: UIFont
        switch type {
        case .light:
            font = UIFont.systemFont(ofSize: size, weight: .light)
        case .normal:
            font = UIFont.systemFont(ofSize: size, weight: .regular)
        case .medium:
            font = UIFont.systemFont(ofSize: size, weight: .medium)
        case .bold:
            font = UIFont.systemFont(ofSize: size, weight: .bold)
        case .semiBold:
            font = UIFont.systemFont(ofSize: size, weight: .semibold)
        case .italic:
            font = UIFont.italicSystemFont(ofSize: size)
        case .boldItalic:
            font = UIFont.systemFont(ofSize: size, weight: .bold).withTraits(traits: [.traitItalic, .traitBold])
        case .black:
            font = UIFont.systemFont(ofSize: size, weight: .black)
        }
        
        guard let traits = traits, let descriptor = font.fontDescriptor.withSymbolicTraits(traits) else {
            return font
        }
        
        return UIFont(descriptor: descriptor, size: 0)
    }
    
    var fontDefaultTitle: UIFont {
        return Theme.current.font(.normal, size: 16)
    }
    
    var primaryTextColor: UIColor {
        return UIColor(red: 79.0 / 255.0, green: 86.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)
    }
}

// MARK: Padding
extension ThemeProtocol {
    var defaultHorizontalPadding: CGFloat {
        return 14.0
    }
}

// MARK: Table
extension ThemeProtocol {
    var tableBackgroundColor: UIColor {
        return UIColor(hex: "F4F7F9")
    }
    
    var primarySeparatorColor: UIColor {
        return UIColor(hex: "E4E8EF")
    }
}

// MARK: - BarButtonItem
extension ThemeProtocol {
    var defaultBarButtonItemColor: UIColor {
        return .white
    }
}
