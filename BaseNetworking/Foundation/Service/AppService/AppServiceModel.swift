//
//  AppServiceModel.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/5/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit

enum AppEnvironmentType: Int, CaseIterable {

    case debug = 1
    case intrelease = 2
    case release = 3

    var stringValue: String {
        switch self {
        case .debug:
            return "DEBUG"
        case .intrelease:
            return "INTRELEASE"
        case .release:
            return "RELEASE"
        }
    }
    
    var prefix: String {
        switch self {
        case .debug:
            return "debug"
        case .intrelease:
            return "intrelease"
        case .release:
            return "release"
        }
    }
}

struct AppEnvironment {

    let config: [String: Any]
    let type: AppEnvironmentType

    init(_ type: AppEnvironmentType) {
        self.type = type
        
        let config = "config_" + type.prefix
        let path = Bundle.main.path(forResource: config, ofType: "plist") ?? ""
        self.config = NSDictionary(contentsOfFile: path) as? [String: Any] ?? [:]
    }
    
    var appHostAddress: String {
        config["AppHostAddress"] as? String ?? "http://abz/api"
    }
}
