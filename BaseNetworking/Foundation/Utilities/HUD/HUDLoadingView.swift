//
//  HUDLoadingView.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/5/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit

class HUDLoadingView: HUDView {
    
    static let kMaxInterval = TimeInterval(SettingKeys.timeoutLoading)
    
    fileprivate var loadingLogoImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadingLogoImageView = UIImageView()
        loadingLogoImageView.image = Theme.current.hudLoadingLogoImage
        loadingLogoImageView.contentMode = .scaleAspectFill
        contentView.addSubview(loadingLogoImageView)
        
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func showInView(_ view: UIView, duration: TimeInterval, completion: CompletionBlock?) {
        super.showInView(view, duration: duration, completion: completion)
        startAnimation()
    }
    
    override func hide() {
        super.hide()
        stopAnimation()
    }
    
    private func startAnimation() {
        
        var transform: CATransform3D = CATransform3DIdentity
        transform.m34 = 1.0 / -1000
        transform = CATransform3DRotate(transform, CGFloat.pi, 0.0, 1.0, 0.0)
        
        self.loadingLogoImageView.layer.transform = transform
        
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .curveEaseInOut], animations: {
            self.loadingLogoImageView.layer.transform = CATransform3DIdentity
        })
    }
    
    private func stopAnimation() {
        loadingLogoImageView.layer.removeAllAnimations()
    }
}

// MARK: Constraints
extension HUDLoadingView {
    
    fileprivate func configureConstraints() {
        
        loadingLogoImageView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView.snp.edges)
                .inset(UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30))
        }
    }
}
