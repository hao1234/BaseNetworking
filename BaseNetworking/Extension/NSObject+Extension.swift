//
//  NSObject+Extension.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/6/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import Foundation

extension NSObject {
    class func name() -> String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
