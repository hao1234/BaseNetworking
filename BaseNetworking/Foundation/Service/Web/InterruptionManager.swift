//
//  InterruptionManager.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/6/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit
import MLWebService

class InterruptionManager: InterruptionWebServiceProtocol {
    
    public func handleInterruption(request: WebRequest?, result: String, retryBlock: RetryInteruptionBlock?) -> Bool {
        return true
    }
    
}
