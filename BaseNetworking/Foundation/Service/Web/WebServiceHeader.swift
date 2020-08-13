//
//  WebServiceHeader.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/6/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit
import MLWebService

class WebServiceHeader: WebServiceHeaderProtocol {

    fileprivate let appService: AppService?
    fileprivate let authService: AuthServiceProtocol?

    init(appService: AppService?,
         authService: AuthServiceProtocol?) {

        self.appService = appService
        self.authService = authService
    }

    func getHeaderInRequest(_ request: WebRequest) -> WebHeaders? {
        guard let appService = self.appService else {
            return [:]
        }
        
        var headers = [
            "Client-Version": appService.appVersion,
            "Client-Id": appService.clientID,
            "Client-Language": Language.sharedInstance.languageCode.rawValue,
        ]

        if let accessToken = authService?.accessToken() {
            headers["Access-Token"] = accessToken
        } else {
            headers["Access-Token"] = ""
        }

        return headers
    }
}
