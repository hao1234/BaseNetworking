//
//  BaseViewController.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/5/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController, BaseMVVMViewControllerProtocol {
    var hudView: HUDView?
    var isCalledDismiss: Bool = false
    var openPath: RouterPath? {
        didSet {
            
            if let path = openPath,
                self.isViewLoaded {
                self.openPath(path)
                self.openPath = nil
            }
        }
    }
    
    private var scrollViewKeyboardController: ScrollViewKeyboardController?
    private var isObservingKeyboard = false
    
    var viewModel: BaseViewModelProtocol
    let disposeBag = DisposeBag()
    var baseViewModel: BaseViewModelProtocol {
        return viewModel
    }
    
    init(viewModel: BaseViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.navigationController?.viewControllers.first !== self {
            let backBarItem = BarButtonItem(image: Theme.current.navigationBarButtonBackImage?.withRenderingMode(.alwaysOriginal),
                                            style: .plain,
                                            target: self,
                                            action: #selector(self.popViewController))
            backBarItem.imageInsets = UIEdgeInsets.init(top: 0, left: -8, bottom: 0, right: 0)
            backBarItem.width = 20
            self.navigationItem.leftBarButtonItems = [backBarItem]
            
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
        self.navigationController?.navigationBar.isTranslucent = false
        
        Logger.vc("\(self) viewDidLoad")
        configureView()
        reconfigureConstraint()
        addObserve()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Logger.vc("\(self) viewWillAppear")
        
        if let path = openPath {
            openPath(path)
            openPath = nil
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Logger.logCrashlytics(string: "\(self) viewWillDisAppear")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func popViewController(_ sender: Any!) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func configureView() {
        // Override to add subview
    }
    
    
    func reconfigureConstraint() {
        // Override to add constraint
    }

    func addObserve() {
        // Setup binding viewmodel
        handleDefaultRelay()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        Logger.logCrashlytics(string: "\(self) didReceiveMemoryWarning")
    }
    
    @discardableResult func openPath(_ path: RouterPath) -> Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        isCalledDismiss = true
    }
    
    deinit {
        removeObserveKeyboardChange()
        Logger.vc("\(self) deinit")
        Logger.logCrashlytics(string: "\(self) deinit")
    }
}

extension BaseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension BaseViewController: HUDShowable {
    func viewForHUD() -> UIView {
        return rootParentViewController()?.view ?? view
    }
}

// MARK: - Keyboard
extension BaseViewController: KeyboardEvents {
    func keyboardWillShowWithRect(
        _ rect: CGRect,
        duration: TimeInterval,
        animationOptions: UIView.AnimationOptions = []
    ) {
        scrollViewKeyboardController?.keyboardWillShowWithRect(
            rect,
            duration: duration,
            animationOptions: animationOptions)
    }
    
    func keyboardWillHideWithRect(
        _ rect: CGRect,
        duration: TimeInterval,
        animationOptions: UIView.AnimationOptions = []
    ) {
        scrollViewKeyboardController?.keyboardWillHideWithRect(
            rect,
            duration: duration,
            animationOptions: animationOptions)
    }
    
    func observeKeyboardChange() {
        KeyboardNotifier.sharedInstance.subscribeEvents(self)
    }
    
    func removeObserveKeyboardChange() {
        KeyboardNotifier.sharedInstance.unsubscribeEvents(self)
    }
    
    func adjustScrollViewInsetsForKeyboardChange(_ scrollView: UIScrollView) {
        
        observeKeyboardChange()
        
        if scrollViewKeyboardController == nil {
            scrollViewKeyboardController = ScrollViewKeyboardController()
        }
        scrollViewKeyboardController!.scrollView = scrollView
    }
    
    @discardableResult
    func addTapScreenDismissKeyboard() -> UIGestureRecognizer {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.endEditing))
        self.view.addGestureRecognizer(tapGesture)
        return tapGesture
    }
    
    @objc fileprivate func endEditing() {
        self.view.endEditing(true)
    }
}
