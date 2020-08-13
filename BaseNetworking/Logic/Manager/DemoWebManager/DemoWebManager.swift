//
//  DemoWebManager.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/6/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit
import MLWebService

final class DemoWebManager: NSObject {
    private let webAPI: ADemoWebAPIProtocol
    
    init(webProvider: WebProviderProtocol) {
        webAPI = DemoWebAPI(webProvider: webProvider)
        super.init()
    }
    
    func requestAPIDemo1(param1: String, parame2: Int, completion: GenericResponseBlock<[DemoModel]>?) {
        webAPI.requestAPIDemo1(
            param1: param1,
            parame2: parame2,
            completion: completion)
    }
    func requestAPIDemo2(param1: Int, completion: ErrorTypeBlock?) {
        webAPI.requestAPIDemo2(param1: param1, completion: completion)
    }
}
