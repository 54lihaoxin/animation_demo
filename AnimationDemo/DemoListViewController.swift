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
        
        var description: String {
            switch self {
            case .wwdc2017:
                return "WWDC 2017"
            }
        }
    }
    
    fileprivate enum WWDC2017Item: Int, CaseIterable, CustomStringConvertible {
        case session230_AdvancedAnimationsWithUIKit
        
        static let allCases: [WWDC2017Item] = {
            return [session230_AdvancedAnimationsWithUIKit]
        }()
        
        var description: String {
            switch self {
            case .session230_AdvancedAnimationsWithUIKit:
                return "230 - Advanced Animations With UIKit"
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
        guard let sectionCase = Section(rawValue: section) else {
            assertionFailure()
            return 0
        }
        
        switch sectionCase {
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
        guard let sectionCase = Section(rawValue: section) else {
            assertionFailure()
            return nil
        }
        
        return sectionCase.description
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else {
            assertionFailure()
            return
        }
        
        switch section {
        case .wwdc2017:
            guard let row = WWDC2017Item(rawValue: indexPath.row) else {
                assertionFailure()
                return
            }
            cell.textLabel?.text = row.description
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO
    }
}
