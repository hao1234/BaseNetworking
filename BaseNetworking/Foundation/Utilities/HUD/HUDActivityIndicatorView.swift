//
//  HUDActivityIndicatorView.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/5/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit
import SnapKit

class HUDActivityIndicatorView: HUDView {
    static let kMaxInterval = TimeInterval(180)

    fileprivate var loadingActivityView: UIActivityIndicatorView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        loadingActivityView = UIActivityIndicatorView(style: .whiteLarge)
        contentView.addSubview(loadingActivityView)
        isEnableLongPressDismiss = false
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
        loadingActivityView.startAnimating()
    }

    private func stopAnimation() {
        loadingActivityView.stopAnimating()
    }
}

// MARK: Constraints
extension HUDActivityIndicatorView {
    fileprivate func configureConstraints() {
        loadingActivityView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView.snp.edges)
                .inset(UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30))
        }
    }
}
