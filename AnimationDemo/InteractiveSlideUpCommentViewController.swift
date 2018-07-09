//
//  InteractiveSlideUpCommentViewController.swift
//  AnimationDemo
//
//  Created by Haoxin Li on 7/8/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import UIKit

class InteractiveSlideUpCommentViewController: UIViewController {

    @IBOutlet fileprivate weak var imageView: UIImageView!
    private var originalHideNavigationBarOnTap = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let nav = navigationController {
            originalHideNavigationBarOnTap = nav.hidesBarsOnTap
            nav.hidesBarsOnTap = true
        }
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        if parent == nil, let nav = navigationController {
            nav.hidesBarsOnTap = originalHideNavigationBarOnTap
        }
    }
}
