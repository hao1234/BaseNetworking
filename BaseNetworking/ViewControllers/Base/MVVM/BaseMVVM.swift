//
//  BaseMVVM.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/6/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import RxSwift
import RxCocoa

protocol BaseViewModelProtocol: class {
    var messageRelay: BehaviorRelay<Message?> { get }
    var loadingRelay: BehaviorRelay<Bool> { get }
    var navigationRelay: PublishSubject<NavigationAction?> { get }
}

class ViewModel: BaseViewModelProtocol {
    let messageRelay = BehaviorRelay<Message?>(value: nil)
    let loadingRelay = BehaviorRelay<Bool>(value: false)
    let navigationRelay = PublishSubject<NavigationAction?>()

    deinit {
    }
}

enum Message {
    case success(message: String)
    case error(message: String, completion: EmptyBlock? = nil)
}

enum NavigationAction {
    case present(vc: UIViewController, animated: Bool = true, completion: EmptyBlock? = nil)
    case push(vc: UIViewController, animated: Bool = true, completion: EmptyBlock? = nil)
    case pop(vc: UIViewController?, animated: Bool = true, completion: EmptyBlock? = nil)
    case web(url: URL)
    case dismiss(vc: UIViewController, animated: Bool = true, completion: EmptyBlock? = nil)
}

protocol Navigationable {
    var navigationController: UINavigationController? { get }
}

protocol BaseMVVMViewControllerProtocol: HUDShowable, Navigationable {
    var baseViewModel: BaseViewModelProtocol { get }
    var disposeBag: DisposeBag { get }
    func handleMessageRelay()
    func handleLoadingRelay()
    func handleNavigation()
}

extension BaseMVVMViewControllerProtocol {
    func handleDefaultRelay() {
        handleMessageRelay()
        handleLoadingRelay()
        handleNavigation()
    }
    
    func handleMessageRelay() {
        baseViewModel.messageRelay.bind { [unowned self] message in
            guard let message = message else { return }
            self.hudHide()
            switch message {
            case let .error(content, _):
                self.hudShowErrorText(content)
            case let .success(conent):
                self.hudShowSuccessText(conent)
            }
        }.disposed(by: disposeBag)
    }
    
    func handleLoadingRelay() {
        baseViewModel.loadingRelay.bind { [unowned self] isLoading in
            if isLoading {
                self.hudShowLoading()
            } else {
                self.hudHide()
            }
        }.disposed(by: disposeBag)
    }
    
    func handleNavigation() {
        baseViewModel.navigationRelay.bind { [unowned self] action in
            guard let action = action else { return }
            switch action {
            case let .present(vc, animated, completion):
                ClientStream.session.managerUI.present(
                    viewController: vc,
                    animated: animated,
                    completion: completion)
            case let .push(vc, animated, completion):
                ClientStream.session.managerUI.pushNavigationController(
                    viewController: vc,
                    animated: animated,
                    completion: completion)
            case let .pop(vc, animated, completion):
                guard let vc = vc else {
                    self.navigationController?.popViewControllerWithHandler(
                        poptoRoot: false,
                        animated: animated,
                        completion: completion)
                    return
                }
                self.navigationController?.popToViewControllerWithHandler(
                    vc: vc,
                    animated: animated,
                    completion: completion)
            case let .web(url):
                print("Update later \(url)")
            case let .dismiss(vc, animated, completion):
                vc.dismiss(animated: animated, completion: completion)
            }
        }.disposed(by: disposeBag)
    }
}
