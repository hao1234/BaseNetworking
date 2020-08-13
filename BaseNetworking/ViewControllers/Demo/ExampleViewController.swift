//
//  ExampleViewController.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/6/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit
import Actions

final class ExampleViewController: BaseViewController {

    private var exampleViewModel: ExampleViewModel? {
        return viewModel as? ExampleViewModel
    }
    
    private lazy var titleLabel = UILabel().build {
        $0.text = L10n.Main.hello("MLTeam")
        $0.font = Theme.current.font(.medium, size: 28)
        $0.textColor = Theme.current.primaryTextColor
    }

    private lazy var nextButton = UIButton().build {
        $0.setTitle(L10n.hello, for: .normal)
        $0.titleLabel?.font = Theme.current.font(.normal, size: 20)
        $0.setTitleColor(Theme.current.primaryTextColor, for: .normal)
    }
    
    private lazy var changeLanguage = UIButton().build {
        $0.setTitle("Change language", for: .normal)
        $0.titleLabel?.font = Theme.current.font(.normal, size: 20)
        $0.setTitleColor(Theme.current.primaryTextColor, for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        exampleViewModel?.viewDidLoad()
    }
    
    override func addObserve() {
        super.addObserve()
        guard let exampleViewModel = exampleViewModel else {
            return
        }
    
        // add some code...
        nextButton.rx.tap.bind {
            exampleViewModel.nextButtonDidTap()
        }.disposed(by: disposeBag)
        
        changeLanguage.rx.tap.bind {
            Language.sharedInstance.updateLanguageCode(.english)
        }.disposed(by: disposeBag)
    }

    override func configureView() {
        super.configureView()
        view.backgroundColor = .white
        title = ClientStream.session.services.app.environment.appHostAddress

        view.addSubviews([titleLabel, nextButton, changeLanguage])
    }
    
    override func reconfigureConstraint() {
        super.reconfigureConstraint()
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(20)
        }
        
        nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
        }
        
        changeLanguage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nextButton.snp.bottom).offset(30)
        }
    }
}
