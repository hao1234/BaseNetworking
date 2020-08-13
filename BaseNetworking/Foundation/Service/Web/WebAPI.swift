//
//  WebAPI.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/6/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import ObjectMapper
import SwiftyJSON
import MLWebService

typealias GenericResponseBlock<T> = (T?, Error?) -> ()

open class WebAPI {
    let webProvider: WebProviderProtocol
    
    init(webProvider: WebProviderProtocol) {
        self.webProvider = webProvider
    }
    
    @discardableResult
    func requestWebAction(
        _ method: WebMethod,
        path: String,
        headers: WebHeaders?,
        parameters: WebParams?,
        requestID: String? = nil,
        timeoutInterval: TimeInterval? = nil,
        completion: ErrorTypeBlock?
    ) -> URLSessionTask? {
        let headers = headers ?? [:]
        let task = self.webProvider.request(
            method: method,
            path: path,
            headers: headers,
            params: parameters,
            encoding: WebEncoding.json,
            cachePolicy: nil,
            uploadProgressBlock: nil,
            downloadProgressBlock: nil,
            timeoutInterval: nil
        ) { result in
            completion?(result.error)
        }
        return task
    }
    
    @discardableResult
       func request<ResponseType>(
           _ method: WebMethod,
           path: String,
           headers: WebHeaders?,
           parameters: WebParams?,
           requestID: String? = nil,
           timeoutInterval: TimeInterval? = nil,
           completion: ((ResponseType?, Error?) -> Void)?,
           jsonHandle: ((JSON) -> ResponseType?)?
       ) -> URLSessionTask? {
        let headers = headers ?? [:]
        let task = self.webProvider.request(
            method: method,
            path: path,
            headers: headers,
            params: parameters,
            encoding: WebEncoding.json,
            cachePolicy: nil,
            uploadProgressBlock: nil,
            downloadProgressBlock: nil,
            timeoutInterval: nil
        ) { [weak self] result in
               self?.handleWebResponseData(
                   result: result,
                   completion: completion) {
                       jsonHandle?($0)
               }
           }
           return task
    }
    
    fileprivate func handleWebResponseData<T>(
        result: Results,
        completion: ((T?,Error?) -> Void)?,
        jsonHandle: ((JSON) -> T?)? = nil
    ) {
        guard let jsonData = result.data else {
            completion?(nil, result.error)
            return
        }
        let data = jsonHandle?(jsonData)
        completion?(data, nil)
    }
    
    private func handleWebActionResponse(
        result: Results,
        completion: ErrorTypeBlock?,
        errorHandle: ((Error?) -> Bool)? = nil
    ) {
        guard let error = result.error else {
            completion?(nil)
            return
        }
        let isNeedCallback = errorHandle?(error) ?? true
        if isNeedCallback {
            completion?(error)
        }
    }
}

extension JSON {
    func getObjectList<T: BaseMappable>(key: String?) -> [T] {
        var results = [T]()
        let arrayData = key == nil ? self.arrayValue : self[key!].arrayValue
        for data in arrayData where data.dictionaryObject != nil {
            if let result = Mapper<T>().map(JSON: data.dictionaryObject ?? [:]) {
                results.append(result)
            }
        }
        return results
    }
    
    func getObject<T: BaseMappable>(key: String? = nil) -> T? {
        let data: [String: Any] = (key == nil ? self.dictionaryObject : self[key!].dictionaryObject) ?? [:]
        let object = Mapper<T>().map(JSON: data)
        return object
    }
    
    func getValue<T: Any>(key: String) -> T? {
        let data: [String: Any] = self.dictionaryObject ?? [:]
        return data[key] as? T
    }
}
