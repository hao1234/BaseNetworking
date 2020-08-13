//
//  AuthServiceProtocol.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/6/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit
import SwiftyLib

public protocol AuthServiceEvent {
    func authServiceDidExchangeTokenSuccess()
    func authServiceDidExchangeTokenFailure(error: Error?)
}

public protocol AuthServiceProtocol {
    func accessToken() -> String?
}

class AuthService: Multicastable, AuthServiceProtocol {
    private static var _shared: AuthServiceProtocol!
    public static private(set) var shared: AuthServiceProtocol! {
        get {
            assert(_shared != nil, "AuthService wasn't initialize yet")
            return self._shared
        } set {
            self._shared = newValue
        }
    }
    
    var multicast = Multicast<AuthServiceEvent>()
    
    public static func initialize() {
        assert(_shared == nil, "AuthService has already existed")
        shared = AuthService()
    }
    
    private init() {
    }
    
    func accessToken() -> String? {
        return nil
    }
}
