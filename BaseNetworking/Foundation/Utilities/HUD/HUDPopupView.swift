//
//  HUDPopupView.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/5/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit

public enum HUDPopupViewType {
    case success
    case warning
    case error
}

class HUDPopupView: HUDView {

    var text: String? {
        set { label.text = newValue }
        get { return label.text }
    }
    
    fileprivate var imageView: UIImageView!
    fileprivate var label: UILabel!
    
     init(_ type: HUDPopupViewType) {
        super.init(frame: .zero)
        
        imageView = UIImageView(image: type.image)
        contentView.addSubview(imageView)
        
        label = UILabel()
        label.font = Theme.current.fontDefaultTitle
        label.textColor = Theme.current.hudTextColor
        label.numberOfLines = 0
        contentView.addSubview(label)
        
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func imageForPopupType(_ type: HUDPopupViewType) -> UIImage? {
        switch type {
        case .success:
            return Theme.current.hudSuccessImage
        case .warning:
            return Theme.current.hudWarningImage
        case .error:
            return Theme.current.hudErrorImage
        }
    }
}

// MARK: Constraints
extension HUDPopupView {
    
    fileprivate func configureConstraints() {
        
        imageView.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(contentView.snp.leading).offset(30)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        imageView.increaseDefaultVerticalCompressionResistanceAndHuggingPriority()
        imageView.increaseDefaultHorizontalCompressionResistanceAndHuggingPriority()
        
        label.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView.snp.top).offset(20)
            make.leading.equalTo(imageView.snp.trailing).offset(Theme.current.defaultHorizontalPadding)
            make.trailing.equalTo(contentView.snp.trailing).offset(-30)
            make.centerY.equalTo(contentView.snp.centerY)
        }
    }
}

extension HUDPopupViewType {
    
    var image: UIImage? {
        
        switch self {
        case .success:
            return Theme.current.hudSuccessImage
        case .warning:
            return Theme.current.hudWarningImage
        case .error:
            return Theme.current.hudErrorImage
        }
    }
}
