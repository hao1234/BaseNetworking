//
//  ExampleViewModel.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/6/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import MLWebService

protocol ExampleViewModelProtocol: BaseViewModelProtocol {
    func viewDidLoad()
    func nextButtonDidTap()
    
}

final class ExampleViewModel: ViewModel, ExampleViewModelProtocol {
    let demoAPI: ADemoWebAPIProtocol
    
    init(demoAPI: ADemoWebAPIProtocol) {
        self.demoAPI = demoAPI
    }
    
    private func loadData() {
        loadingRelay.accept(true)
        demoAPI.requestAPIDemo2(param1: 1, completion: { [weak self] error in
            self?.loadingRelay.accept(false)
            if let error = error {
                self?.messageRelay.accept(.error(message: error.localizedDescription, completion: nil))
            }
        })
    }
    
    func viewDidLoad() {
        Logger.info("viewDidLoad from model")
        loadData()
    }
    
    func nextButtonDidTap() {
        messageRelay.accept(.error(message: "Error"))
    }
}
