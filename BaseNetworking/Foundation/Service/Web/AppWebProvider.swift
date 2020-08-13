//
//  AppWebProvider.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/6/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import MLWebService

final class AppWebProvider: WebProvider {

    init(webService: WebServiceProtocol,
         baseAddress: String,
         appService: AppService?,
         authService: AuthServiceProtocol,
         interruption: InterruptionWebServiceProtocol?) {

        let header = WebServiceHeader(appService: appService,
                                      authService: authService)

        super.init(webService: webService,
                   header: header,
                   interruption: interruption,
                   baseAddress: baseAddress)
    }
}
