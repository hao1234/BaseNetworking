//
//  KeyboardNotifier.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/9/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit
import SwiftyLib

protocol KeyboardEvents: class {
    func keyboardWillShowWithRect(_ rect:CGRect, duration: TimeInterval, animationOptions: UIView.AnimationOptions)
    func keyboardWillHideWithRect(_ rect:CGRect, duration: TimeInterval, animationOptions: UIView.AnimationOptions)
}

final class KeyboardNotifier: Multicastable {
    public static let sharedInstance = KeyboardNotifier()
    public let multicast = Multicast<KeyboardEvents>()
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
            let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue,
            let animation = userInfo.value(forKey: UIResponder.keyboardAnimationDurationUserInfoKey) as? NSNumber,
            let curveInfo = userInfo.value(forKey: UIResponder.keyboardAnimationCurveUserInfoKey) as? NSNumber
            else { return }
        
        let keyboardRectangle = keyboardFrame.cgRectValue
        let animationDuration = animation.doubleValue
        let animationOption = UIView.AnimationOptions(rawValue: UIView.AnimationOptions.RawValue(curveInfo.intValue << 16))
        multicast.invokeMain {
            $0.keyboardWillHideWithRect(
                keyboardRectangle,
                duration: animationDuration,
                animationOptions: animationOption)
        }
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
            let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue,
            let animation = userInfo.value(forKey: UIResponder.keyboardAnimationDurationUserInfoKey) as? NSNumber,
            let curveInfo = userInfo.value(forKey: UIResponder.keyboardAnimationCurveUserInfoKey) as? NSNumber
            else { return }
        
        let keyboardRectangle = keyboardFrame.cgRectValue
        let animationDuration = animation.doubleValue
        let animationOption = UIView.AnimationOptions(rawValue: UIView.AnimationOptions.RawValue(curveInfo.intValue << 16))
        multicast.invokeMain {
            $0.keyboardWillShowWithRect(
                keyboardRectangle,
                duration: animationDuration,
                animationOptions: animationOption)
        }
    }
}
