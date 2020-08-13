//
//  RouterPath.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/5/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

final class RouterPath {
    var path: String
    var delimiter: String
    var firstComponent: String {
        get {
            return path.components(separatedBy: delimiter).first ?? ""
        }
    }
    var nextRouter: RouterPath {
        get {
            var compoment = path.components(separatedBy: delimiter)
            compoment.removeFirst()
            return RouterPath(path: compoment.joined(separator: delimiter), delimiter: delimiter, userInfo: userInfo)
        }
    }
    var userInfo: Any?

    init(path: String, delimiter: String = "/", userInfo: Any? = nil) {
        self.path = path
        self.delimiter = delimiter
        self.userInfo = userInfo
    }
}
