//
//  DemoWebAPI.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/6/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit
import ObjectMapper
import MLWebService

struct DemoModel: Mappable {
    var id: String?
    var description: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        description <- map["description"]
    }
}

protocol ADemoWebAPIProtocol {
    func requestAPIDemo1(param1: String, parame2: Int, completion: GenericResponseBlock<[DemoModel]>?)
    func requestAPIDemo2(param1: Int, completion: ErrorTypeBlock?)
}

final class DemoWebAPI: WebAPI {
    private enum URLPath: String {
        case demo1Path = "photos"
        case demo2Path = "photos2"
    }
}

extension DemoWebAPI: ADemoWebAPIProtocol {
    func requestAPIDemo1(
        param1: String,
        parame2: Int,
        completion: GenericResponseBlock<[DemoModel]>?
    ) {
        let params: WebParams = [
            "page" : param1,
            "client_id" : "L6PMVSiY1LK8d5ai2Y2GN4VBNy-eU1LkQxMM284PpN8"
        ]
        request(
            .get,
            path: URLPath.demo1Path.rawValue,
            headers: nil,
            parameters: params,
            completion: completion
        ) { json -> [DemoModel]? in
            return json.getObjectList(key: nil)
        }
    }
    
    func requestAPIDemo2(param1: Int, completion: ErrorTypeBlock?) {
        let params: WebParams = [
            "page" : param1,
            "client_id" : "L6PMVSiY1LK8d5ai2Y2GN4VBNy-eU1LkQxMM284PpN8"
        ]
        
        requestWebAction(
            .get,
            path: URLPath.demo2Path.rawValue,
            headers: nil,
            parameters: params,
            completion: completion)
    }
}
