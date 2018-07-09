//
//  DemoListViewController.swift
//  AnimationDemo
//
//  Created by Haoxin Li on 7/8/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import UIKit

final class DemoListViewController: UIViewController {
    
    fileprivate enum Section: Int, CaseIterable, CustomStringConvertible {
        case wwdc2017
        
        static let allCases: [Section] = {
            return [wwdc2017]
        }()
        
        static func section(for sectionNumber: Int) -> Section {
            guard let section = Section(rawValue: sectionNumber) else {
                fatalError()
            }
            return section
        }
        
        var description: String {
            switch self {
            case .wwdc2017:
                return "WWDC 2017"
            }
        }
    }
    
    fileprivate enum WWDC2017Item: Int, CaseIterable, CustomStringConvertible {
        case session230_AdvancedAnimationsWithUIKitDemo1
        case session230_AdvancedAnimationsWithUIKitDemo2
        
        static let allCases: [WWDC2017Item] = {
            return [session230_AdvancedAnimationsWithUIKitDemo1,
                    session230_AdvancedAnimationsWithUIKitDemo2]
        }()
        
        static func item(for itemNumber: Int) -> WWDC2017Item {
            guard let item = WWDC2017Item(rawValue: itemNumber) else {
                fatalError()
            }
            return item
        }
        
        var description: String {
            switch self {
            case .session230_AdvancedAnimationsWithUIKitDemo1:
                return "230.1 - Advanced Animations With UIKit Demo 1"
            case .session230_AdvancedAnimationsWithUIKitDemo2:
                return "230.2 - Advanced Animations With UIKit Demo 2"
            }
        }
    }
    
    fileprivate static let cellReuseIdentifier = "ReuseID"
    
    fileprivate lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.dataSource = self
        tv.delegate = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: DemoListViewController.cellReuseIdentifier)
        return tv
    }()
    
    override func loadView() {
        super.loadView()
        
        title = "Animation Demo"
        view.addSubview(tableView)
        tableView.activateLayoutAnchorsWithSuperView()
    }
}

extension DemoListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section.section(for: section) {
        case .wwdc2017:
            return WWDC2017Item.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: DemoListViewController.cellReuseIdentifier, for: indexPath)
    }
}

extension DemoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section.section(for: section).description
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch Section.section(for: indexPath.section) {
        case .wwdc2017:
            guard let row = WWDC2017Item(rawValue: indexPath.row) else {
                assertionFailure()
                return
            }
            cell.textLabel?.text = row.description
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let navigationController = navigationController else {
            fatalError()
        }
        switch Section.section(for: indexPath.section) {
        case .wwdc2017:
            switch WWDC2017Item.item(for: indexPath.row) {
            case .session230_AdvancedAnimationsWithUIKitDemo1:
                navigationController.pushViewController(InteractiveSlidingBlockViewController(), animated: true)
            case .session230_AdvancedAnimationsWithUIKitDemo2:
                navigationController.pushViewController(InteractiveSlideUpCommentViewController(), animated: true)
            }
        }
    }
}
