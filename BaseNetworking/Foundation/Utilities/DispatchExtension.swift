//
//  DispatchExtension.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/5/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import Foundation

func dispatch_async_main_queue(_ excute: @escaping () -> Void) {
    DispatchQueue.main.async {
        excute()
    }
}

func dispatch_main_queue_async_if_needed(_ excute: @escaping () -> Void) {
    if Thread.isMainThread {
        excute()
        return
    }
    DispatchQueue.main.async {
        excute()
    }
}

func dispatch_sync_main_queue_safe(_ excute: @escaping () -> Void) {
    if Thread.isMainThread {
        excute()
        return
    }

    DispatchQueue.main.sync {
        excute()
    }
}

extension DispatchQueue {
    class var currentLabel: String? {
        return String(validatingUTF8: __dispatch_queue_get_label(nil))
    }
    
    func syncSafe(_ block: EmptyBlock) {
        if DispatchQueue.currentLabel == self.label {
            block()
            return
        }
        self.sync(execute: block)
    }
}
