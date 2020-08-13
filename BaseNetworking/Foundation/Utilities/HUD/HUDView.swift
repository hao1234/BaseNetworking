//
//  HUD.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/5/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit

class HUDView: UIView {

    typealias CompletionBlock = () -> ()

    var isShowing: Bool {
        return (superview != nil)
    }
    
    var hudBackgroundColor: UIColor? = Theme.current.hudBackgroundColor {
        didSet {
            hudView.backgroundColor = hudBackgroundColor
        }
    }
    
    fileprivate(set) var contentView: UIView!
    fileprivate var hudView: UIView!
    fileprivate var completionBlock: CompletionBlock?
    
    fileprivate let kAnimationDuration = TimeInterval(0.2)
    fileprivate lazy var pressGesture: UILongPressGestureRecognizer = {
        let pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.hide))
        pressGesture.minimumPressDuration = 0.7

        return pressGesture
    }()

    var isEnableLongPressDismiss: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        isUserInteractionEnabled = true
        alpha = 0
        
        hudView = UIView()
        hudView.layer.cornerRadius = 10
        hudView.layer.shadowColor = Theme.current.hudShadowColor.cgColor
        hudView.layer.shadowOpacity = 0.2
        hudView.layer.shadowRadius = 20
        hudView.layer.shadowOffset = CGSize(width: 0, height: 14)
        hudView.backgroundColor = Theme.current.hudBackgroundColor
        addSubview(hudView)
        
        contentView = UIView()
        hudView.addSubview(contentView)
        
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func durationForText(_ text: String) -> TimeInterval {
        let kLengthPerUnit = 10
        let kDurationPerUnit = TimeInterval(0.5)
        let kMinDuration = TimeInterval(2.0)
        
        let numberOfUnits = Int(ceil(Double(text.count) / Double(kLengthPerUnit)))
        let duration = TimeInterval(numberOfUnits)*kDurationPerUnit
        return max(duration, kMinDuration)
    }
    
    func showInView(_ view: UIView, duration: TimeInterval = 0, completion: CompletionBlock? = nil) {
        
        showInView(view)
        self.completionBlock = completion
        if duration > 0 {
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
                [weak self] in
                guard let me = self else { return }
                
                me.hide()
                completion?()
            }
        }
    }
    
    @objc func hide() {

        self.removeGestureRecognizer(pressGesture)

        UIView.animate(
            withDuration: kAnimationDuration, delay: 0, usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0, options: [],
            animations: { [weak self] in
                self?.hudView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self?.alpha = 0
            },
            completion: { [weak self] (finished) in
                self?.hudView.removeFromSuperview()
                self?.removeFromSuperview()
                self?.completionBlock?()
            }
        )
    }
    
    fileprivate func showInView(_ view: UIView) {
        
        frame = view.bounds
        view.addSubview(self)

        if isEnableLongPressDismiss {
            self.addGestureRecognizer(pressGesture)
            self.isUserInteractionEnabled = true
        }

        hudView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(
            withDuration: kAnimationDuration, delay: 0, usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0, options: [],
            animations: {
                self.hudView.transform = CGAffineTransform.identity
                self.alpha = 1
            },
            completion: nil)
    }

}

// MARK: Constraints
extension HUDView {
    
    fileprivate func configureConstraints() {
        
        hudView.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(self.snp.center)
            make.leading.greaterThanOrEqualTo(self.snp.leading).offset(24)
            make.top.greaterThanOrEqualTo(self.snp.top).offset(40)
        }
        
        contentView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(hudView)
        }
    }
}
