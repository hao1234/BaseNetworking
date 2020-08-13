//
//  Language.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/5/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import Foundation
import SwiftyLib

public protocol LanguageEvents: class {
    func languageDidChanged()
}

public enum LanguageCode: String, CaseIterable {
    case english    = "en"
    case vietnamese = "vi"
}

public class Language: Multicastable {
    public static let sharedInstance = Language()
    public let multicast = Multicast<LanguageEvents>()
    
    public private(set) var languageCode: LanguageCode = .vietnamese {
        didSet {
            guard languageCode != oldValue else { return }
            NotificationCenter.default.post(
                name: .LanguageDidChanged,
                object: self,
                userInfo: nil)
            multicast.invokeMain {
                $0.languageDidChanged()
            }
        }
    }
    
    public func updateLanguageCode(_ languageCode: LanguageCode) {
        self.languageCode = languageCode
        // should save for next session
    }
}
