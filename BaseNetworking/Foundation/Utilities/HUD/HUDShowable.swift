//
//  HUDProtocol.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/2/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit

protocol HUDShowable: class {
    
    var hudView: HUDView? { get set }
    func viewForHUD() -> UIView
}

extension HUDShowable {
    
    var isShowingHUD: Bool {
        return hudView?.isShowing ?? false
    }
    
    func hudHide() {
        hudView?.hide()
    }
    
    func hudShowLoading(_ duration: TimeInterval = HUDLoadingView.kMaxInterval, completion: EmptyBlock? = nil) {
        hudShowLoading(inView: viewForHUD(), duration: duration, completion: completion)
    }
    
    func hudShowLoading(inView view: UIView, duration: TimeInterval = HUDLoadingView.kMaxInterval, completion: EmptyBlock? = nil) {
        let hudView = HUDActivityIndicatorView()
        hudView.hudBackgroundColor = Theme.current.hudLoadingBackgroundColor
        showHudView(hudView, inView: view, duration: duration, completion: completion)
    }
    
    func hudShowSuccessText(_ text: String, completion: HUDView.CompletionBlock? = nil) {
        hudShowSuccessText(text, inView: viewForHUD(), completion: completion)
    }
    
    func hudShowSuccessText(_ text: String, inView view: UIView, completion: HUDView.CompletionBlock?) {
        let duration = HUDView.durationForText(text)
        let hudView = HUDPopupView(.success)
        hudView.text = text
        showHudView(hudView, inView: view, duration: duration, completion: completion)
    }
    
    func hudShowWarningText(_ text: String, completion: HUDView.CompletionBlock? = nil) {
        hudShowWarningText(text, inView: viewForHUD(), completion: completion)
    }
    
    func hudShowWarningText(_ text: String, inView view: UIView, completion: HUDView.CompletionBlock?) {
        let duration = HUDView.durationForText(text)
        let hudView = HUDPopupView(.warning)
        hudView.text = text
        showHudView(hudView, inView: view, duration: duration, completion: completion)
    }
    
    func hudShowErrorText(_ text: String, completion: HUDView.CompletionBlock? = nil) {
        hudShowErrorText(text, inView: viewForHUD(), completion: completion)
    }
    
    func hudShowErrorText(_ text: String, inView view: UIView, completion: HUDView.CompletionBlock? = nil) {
        let duration = HUDView.durationForText(text)
        let hudView = HUDPopupView(.error)
        hudView.text = text
        showHudView(hudView, inView: view, duration: duration, completion: completion)
    }
    
    fileprivate func showHudView(_ hudView: HUDView, inView view: UIView,
                                      duration: TimeInterval, completion: HUDView.CompletionBlock?) {
        
        self.hudView?.hide()
        self.hudView?.removeFromSuperview()
        
        hudView.showInView(view, duration: duration, completion: completion)
        self.hudView = hudView
    }
}
