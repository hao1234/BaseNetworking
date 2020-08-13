//
//  UIColorExtension.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/2/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit

extension UIColor {
    func image(_ size: CGSize=CGSize(width: 1, height: 1)) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext();

        context?.setFillColor(cgColor);
        context?.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();

        UIGraphicsEndImageContext();

        return image
    }
}

public extension UIColor {
    
    /**
     Initialize and returns a color object using the specified hex and alpha values.
     - Parameters:
        - hex: Hex value between `0x000000` and `0xFFFFFF` of the following format `0xrrggbb`
        - alpha: Alpha value between 0.0 and 1.0, defaults to 1.0.
     */
    convenience init(hex: Int, alpha: CGFloat = 1) {
        self.init(hex6: hex, alpha: alpha)
    }
    
    /**
     Initialize and returns a color object using the specified hex string and alpha value.
     - Accepts strings prefixed with `"0x"` and `"#"`
     - Handles both upper and lower case hex string.
     - Parameters:
         - hex: Hex string of the following format:
            - `"rgb"`: `"000-fff"`
            - `"rrggbb"`: `"000000-ffffff"`
         - alpha: Alpha value between 0.0 and 1.0, defaults to 1.0.
     */
    
    convenience init(hex: String, alpha: CGFloat = 1) {
        var hex = hex

        if hex.hasPrefix("0x") {
            hex.removePrefix("0x")
        } else if hex.hasPrefix("#") {
            hex.removePrefix("#")
        }

        guard let value = Int(hex, radix: 16) else {
            self.init(); return
        }

        switch hex.count {
        case 3:
            self.init(hex3: value, alpha: alpha)
        case 6:
            self.init(hex6: value, alpha: alpha)
        default:
            self.init()
        }
    }
}

extension UIColor {
    private convenience init(hex3: Int, alpha: CGFloat) {
        let r = (hex3 & 0xF00) >> 8
        let g = (hex3 & 0x0F0) >> 4
        let b = (hex3 & 0x00F) >> 0
        
        self.init(red256:   (r << 4) + r,
                  green256: (g << 4) + g,
                  blue256:  (b << 4) + b,
                  alpha: alpha)
    }
    
    private convenience init(hex6: Int, alpha: CGFloat) {
        self.init(red256:   (hex6 & 0xFF0000) >> 16,
                  green256: (hex6 & 0x00FF00) >> 8,
                  blue256:  (hex6 & 0x0000FF) >> 0,
                  alpha: alpha)
    }
    
    private convenience init(red256: Int, green256: Int, blue256: Int, alpha: CGFloat) {
        self.init(red:   CGFloat(red256)   / 255.0,
                  green: CGFloat(green256) / 255.0,
                  blue:  CGFloat(blue256)  / 255.0,
                  alpha: alpha)
    }
}
