//
//  TableViewController.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/6/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import SwiftyLib

extension UITableView {
    func setAdapter(_ adapter: AdapterDatasource) {
        dataSource = adapter
        delegate = adapter
        reloadData()
    }
}

class TableViewController: BaseViewController {
    
    var minimumRefreshInterval: TimeInterval = 0.4
    var tableViewStyle: UITableView.Style {
        .plain
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: tableViewStyle)
        tableView.backgroundColor = Theme.current.tableBackgroundColor
        tableView.separatorColor = Theme.current.primarySeparatorColor
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        return tableView
    }()
    
    // MARK:- Placeholder no data
    var shouldAutoShowPlaceHolderWhenEmpty: Bool = true
    var isShowPlaceHolderView: Bool = false {
        didSet {
            placeholderStatusChanged(oldValue: oldValue)
        }
    }
    var placeHolderEmptyText: String = "Danh sách trống" {
        didSet {
            placeHolderLabel.text = self.placeHolderEmptyText
        }
    }
    let placeHolderImageView = UIImageView(image: IMG.tab_bar_ic_chat_active.image)
    private lazy var placeHolderView: UIView = {
        let view = UIView()
        view.addSubview(placeHolderImageView)
        view.addSubview(placeHolderLabel)
        return view
    }()

    private lazy var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.text = placeHolderEmptyText
        label.textColor = Theme.current.primaryTextColor.withAlphaComponent(0.4)
        label.font = Theme.current.fontDefaultTitle
        label.numberOfLines = -1
        label.textAlignment = .center
        return label
    }()
    
    var adapter: AdapterDatasource!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        buildDatasource()
    }
    
    func buildDatasource() {
        guard let adapter = adapter else {
            return
        }
        tableView.setAdapter(adapter)
    }
    
    override func configureView() {
        super.configureView()
        view.addSubview(tableView)
    }
    
    override func reconfigureConstraint() {
        tableView.snp.makeConstraints {
            if #available(iOS 11.0, *) {
                $0.edges.equalTo(view.safeAreaLayoutGuide)
            } else {
                $0.edges.equalTo(view)
            }
        }
    }
    
    private func reconfigurePlaceholderConstraint() {
        placeHolderView.snp.remakeConstraints {
            $0.center.equalToSuperview()
        }

        placeHolderImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }

        placeHolderLabel.snp.makeConstraints {
            $0.top.equalTo(placeHolderImageView.snp.bottom).offset(5)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.width.lessThanOrEqualTo(view.snp.width).multipliedBy(0.5)
        }

        placeHolderView.sizeToFit()
        tableView.layoutIfNeeded()
    }
    
    func refresh() {
        buildDatasource()
        showPlaceHolderIfNeeded()
    }
    
    func placeholderStatusChanged(oldValue: Bool) {
        if isShowPlaceHolderView == oldValue { return }
        
        placeHolderView.removeFromSuperview()
        if isShowPlaceHolderView {
            tableView.addSubview(placeHolderView)
            reconfigurePlaceholderConstraint()
        }
    }
    
    private func showPlaceHolderIfNeeded() {
        if shouldAutoShowPlaceHolderWhenEmpty {
            if let sections = adapter?.sections {
                let count = sections.reduce(0, { (sum, section) -> Int in
                    sum + section.rows.count
                })
                isShowPlaceHolderView = count == 0
            } else {
                isShowPlaceHolderView = true
            }
        }
    }
}

class PullToRefreshHeaderAnimator: ESRefreshHeaderAnimator {

    override var pullToRefreshDescription: String {
        get {
            return L10n.pullToRefresh
        } set {}
    }

    override var releaseToRefreshDescription: String {
        get {
            return "Thả để làm mới"
        } set {}
    }

    override var loadingDescription: String {
        get {
            return "Đang tải"
        } set {}
    }
}

class FooterRefreshLoadMoreAnimatior: ESRefreshFooterAnimator {

    override var loadingMoreDescription: String {
        get {
            return "Tải thêm"
        } set {}
    }

    override var noMoreDataDescription: String {
        get {
            return "Không có thêm dữ liệu"
        } set {}
    }

    override var loadingDescription: String {
        get {
            return "Đang tải"
        } set {}
    }

    override func refresh(
        view: ESRefreshComponent,
        stateDidChange state: ESRefreshViewState
    ) {
        super.refresh(view: view, stateDidChange: state)
        
        subviews.forEach {
            $0.sizeToFit()
        }
        layoutIfNeeded()
    }
}

protocol ScrollViewPullToRefreshProtocol {
    func startPullToRefresh()
    func stopPullToRefresh()
    func stopPullToRefreshImmediately()
    func stopLoadMore()
    func addPullToRefresh(completion: @escaping () -> Void)
    func addLoadMore(completion: @escaping () -> Void)
    func removePullToRefresh()
    func removeLoadMore()
    func noticeNoMoreData()
    func resetNoMoreData()
    func isRefreshing() -> Bool
    func isFooterExisted() -> Bool
}

// MARK: Refresh
extension TableViewController: ScrollViewPullToRefreshProtocol {
    func isFooterExisted() -> Bool {
        return tableView.es.base.footer != nil
    }

    func startPullToRefresh() {
        tableView.es.startPullToRefresh()
    }

    func stopPullToRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + minimumRefreshInterval
        ) { [weak self] in
            guard let self = self else {return}
            self.stopPullToRefreshImmediately()
        }
    }

    @objc func stopPullToRefreshImmediately() {
        tableView.es.stopPullToRefresh()
    }

    func stopLoadMore() {
        tableView.es.stopLoadingMore()
    }

    func addPullToRefresh(completion: @escaping () -> Void) {
        tableView.es.addPullToRefresh(
            animator: PullToRefreshHeaderAnimator(),
            handler: completion)
    }

    func addLoadMore(completion: @escaping () -> Void) {
    tableView.es.addInfiniteScrolling(
        animator: FooterRefreshLoadMoreAnimatior(),
        handler: completion)
    }

    func removePullToRefresh() {
        tableView.es.removeRefreshHeader()
        tableView.isScrollEnabled = true
    }

    func removeLoadMore() {
        if let heightFooter = tableView.footer?.frame.height {
            tableView.contentInset.bottom -= heightFooter
        }
        tableView.es.removeRefreshFooter()
    }

    func noticeNoMoreData() {
        tableView.es.noticeNoMoreData()
    }

    func resetNoMoreData() {
        tableView.es.resetNoMoreData()
    }

    func isRefreshing() -> Bool {
        return tableView.es.base.header?.isRefreshing ?? false || tableView.es.base.footer?.isRefreshing ?? false
    }
}
