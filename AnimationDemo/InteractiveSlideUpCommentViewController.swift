//
//  InteractiveSlideUpCommentViewController.swift
//  AnimationDemo
//
//  Created by Haoxin Li on 7/8/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import UIKit

final class InteractiveSlideUpCommentViewController: UIViewController {

    @IBOutlet fileprivate weak var imageView: UIImageView!
    private var _originalHideNavigationBarOnTap = false
    private var _navigationController: UINavigationController? // `navigationController` is nil when didMove(toParentViewController parent:) is called for dismiss
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let nav = navigationController {
            _navigationController = nav
            _originalHideNavigationBarOnTap = nav.hidesBarsOnTap
            nav.hidesBarsOnTap = true
        }
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        if parent == nil, let nav = _navigationController {
            _navigationController = nil
            nav.hidesBarsOnTap = _originalHideNavigationBarOnTap
        }
    }
}
