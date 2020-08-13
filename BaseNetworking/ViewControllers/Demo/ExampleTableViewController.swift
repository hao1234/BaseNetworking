//
//  ExampleTableViewController.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/6/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import SwiftyLib
import Actions

// MARK:- template 1

class AccountCell2: BaseTableViewCell {
    
    lazy var titleLabel1 = UILabel().build {
        $0.font = Theme.current.font(.normal, size: 20)
        $0.textColor = Theme.current.primaryTextColor
    }
    
    lazy var titleLabel2 = UILabel().build {
        $0.font = Theme.current.font(.medium, size: 20)
        $0.textColor = Theme.current.primaryTextColor
    }
    
    lazy var titleLabel3 = UILabel().build {
        $0.font = Theme.current.font(.bold, size: 20)
        $0.textColor = Theme.current.primaryTextColor
    }
    
    override func configureView() {
        self.showTopBorder = false
        self.showBottomBorder = true
        addSubviews([titleLabel1, titleLabel2, titleLabel3])
    }
    
    override func configureConstraint() {
        titleLabel1.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(10)
        }
        
        titleLabel2.snp.makeConstraints {
            $0.top.equalTo(titleLabel1.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        titleLabel3.snp.makeConstraints {
            $0.top.equalTo(titleLabel2.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
}

final class AccountElement: Element {
    let account: Account
    var titleheader = "abc"
    init(account: Account) {
        self.account = account
    }
    
    override func cellClass() -> AnyClass! {
        AccountCell2.self
    }
    
    override func cell(for tableView: UITableView!, indexPath: IndexPath) -> UITableViewCell {
        let cell = super.cell(for: tableView, indexPath: indexPath)
        if let cell = cell as? AccountCell2 {
            cell.titleLabel1.text = account.id
            cell.titleLabel2.text = "Description...."
            cell.titleLabel3.text = "End...."
        }
        return cell
    }
}

final class UserElement: Element {
    let user: User
    var titleheader = "xyz"
    
    init(user: User) {
        self.user = user
    }
    
    override func cellClass() -> AnyClass! {
        UserCell.self
    }
    
    override func cell(for tableView: UITableView!, indexPath: IndexPath) -> UITableViewCell {
        let cell = super.cell(for: tableView, indexPath: indexPath)
        if let cell = cell as? UserCell {
            cell.titleLabel1.text = user.name
        }
        return cell
    }
}

// MARK:- template 2

// Usage
struct User {
    let name: String
}
class UserCell: BaseTableViewCell {
    lazy var titleLabel1 = UILabel().build {
        $0.font = Theme.current.font(.normal, size: 20)
        $0.textColor = Theme.current.primaryTextColor
    }
    
    override func configureView() {
        self.showTopBorder = false
        self.showBottomBorder = true
        self.bottomBorderLeftPadding = 10
        self.bottomBorderRightPadding = 10
        self.borderColor = .red
        addSubviews([titleLabel1])
    }
    
    override func configureConstraint() {
        titleLabel1.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(10)
        }
    }
}

struct Account {
    let id: String
}

final class ExampleTableViewController: TableViewController {

    let users = [User(name: "Test User 0"),
                 User(name: "Test User 1"),
                 User(name: "Test User 2"),
                 User(name: "Test User 3"),
                 User(name: "Test User 4"),
                 User(name: "Test User 5"),
                 User(name: "Test User 6"),
                 User(name: "Test User 3"),
                 User(name: "Test User 4"),
                 User(name: "Test User 5"),
                 User(name: "Test User 6")]
    var accsBackup = [Account(id: "test_acc"),
                Account(id: "test_acc"),
                Account(id: "test_acc"),
                Account(id: "test_acc"),
                Account(id: "test_acc"),
                Account(id: "test_acc"),
                Account(id: "test_acc"),
                Account(id: "test_acc"),
                Account(id: "test_acc"),
                Account(id: "test_acc")
    ]
    var accs = [Account(id: "test_acc"),
                Account(id: "test_acc"),
                Account(id: "test_acc"),
                Account(id: "test_acc"),
                Account(id: "test_acc"),
                Account(id: "test_acc"),
                Account(id: "test_acc"),
                Account(id: "test_acc"),
                Account(id: "test_acc"),
                Account(id: "test_acc")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ClientStream.session.demoManager.requestAPIDemo1(param1: "1", parame2: 2, completion: { [weak self] data, error in
            print(data)
        })
        addPullToRefresh {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.stopPullToRefresh()
                if self.accs.isEmpty {
                    self.accs += self.accsBackup
                } else {
                    self.accs.removeAll()
                }
                
                self.refresh()
            })
        }
    }
    
    override func buildDatasource() {
        let usersSection = SectionModel()
        let rows: [ElementModel] = users.map {
            UserElement(user: $0)
        }
        usersSection.rows += rows
        let accountsSection = SectionModel()

        let rows2: [AccountElement] = accs.map {
            let element = AccountElement(account: $0).build {
                $0.titleheader = "hiiii"
            }
            element.addAction { [weak self] _ in
                print(element.titleheader)
            }
            
            return element
        }
        accountsSection.rows += rows2
        accountsSection.headerView = UIView().build {
            $0.backgroundColor = .yellow
            $0.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
        }
        adapter = AdapterDatasource(sections: [usersSection, accountsSection])
        tableView.setAdapter(adapter)
    }
}
