//
//  Define.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/2/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import Foundation

public typealias EmptyBlock = () -> Void
public typealias SuccessBlock = (Bool) -> Void
public typealias SingleParamBlock<T> = (T) -> Void
public typealias ErrorTypeBlock = (Error?) -> ()
