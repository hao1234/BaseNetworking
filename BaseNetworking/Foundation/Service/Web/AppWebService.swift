//
//  AppWebService.swift
//  Shopiness
//
//  Created by Nguyen Vu Hao on 8/4/20.
//  Copyright © 2020 NCT Corporation. All rights reserved.
//

import UIKit
import MLWebService

class AppWebService: WebService {
    override init(completionBlockQueue: DispatchQueue = .main) {
        super.init(completionBlockQueue: completionBlockQueue)
    }

    override public func httpLog(_ text: String) {
        if self.isLogEnable {
            Logger.http(text)
        }
    }
}
