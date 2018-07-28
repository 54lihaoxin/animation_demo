//
//  InteractiveSlideUpCommentViewController.swift
//  AnimationDemo
//
//  Created by Haoxin Li on 7/8/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import UIKit

final class InteractiveSlideUpCommentViewController: UIViewController {
    
    fileprivate lazy var slideUpCommentViewAnimator: UIViewPropertyAnimator = {
        let animator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1) {
            
            self.blurEffectView.effect = UIBlurEffect(style: .dark) // Note: no handling to pass touches behind this view yet
            
            self.commentContainerViewBottomConstraint.constant = 0 // Note: this constant won't be changed during the lifetime of this animator
            
            // transform the Comments title
            self.commentContainerView.titleLabel.transform = InteractiveSlideUpCommentContainerView.titleScaleTransform
            self.commentContainerView.titleLabel.alpha = 0
            self.commentContainerView.titleLabelTransformed.transform = CGAffineTransform.identity
            self.commentContainerView.titleLabelTransformed.alpha = 1
            
            self.view.layoutIfNeeded()
        }
        animator.pauseAnimation()
        animator.pausesOnCompletion = true // Note: set this to true so that we can flip `isReversed` and then `startAnimation` again
        return animator
    }()
    
    private let blurEffectView = UIVisualEffectView() // start with no effect, and animatable
    private var _originalHideNavigationBarOnTap = false
    private var _navigationController: UINavigationController? // `navigationController` is nil when didMove(toParentViewController parent:) is called for dismiss
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var commentContainerView: InteractiveSlideUpCommentContainerView!
    @IBOutlet private weak var commentContainerViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let nav = navigationController {
            _navigationController = nav
            _originalHideNavigationBarOnTap = nav.hidesBarsOnTap
            //nav.hidesBarsOnTap = true // disable for now
        }
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        if parent == nil, let nav = _navigationController {
            _navigationController = nil
            nav.hidesBarsOnTap = _originalHideNavigationBarOnTap
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "WWDC 2017 - 230.2"
        view.insertSubview(blurEffectView, belowSubview: commentContainerView)
        blurEffectView.activateLayoutAnchorsWithSuperView()
        
        commentContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnCommentContainer(_:))))
        commentContainerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanOnCommentContainer(_:))))
    }
}

final class InteractiveSlideUpCommentContainerView: UIView {
    
    static let contentHeight: CGFloat = 320 // the height of content below the "Comments" title
    static let titleScaleTransform = CGAffineTransform(scaleX: 1.6, y: 1.5) // a rough scale transform for `titleLabel` and `titleLabelTransformed`
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabelTransformed: UILabel! {
        didSet {
            titleLabelTransformed.alpha = 0 // hidden by default
            titleLabelTransformed.transform = InteractiveSlideUpCommentContainerView.titleScaleTransform.inverted() // make smaller by default
        }
    }
}

// MARK: - Private helpers

private extension InteractiveSlideUpCommentViewController {
    
    @objc func handleTapOnCommentContainer(_ tap: UITapGestureRecognizer) {
        if slideUpCommentViewAnimator.fractionComplete == 1 {
            slideUpCommentViewAnimator.isReversed = !slideUpCommentViewAnimator.isReversed
        }
        slideUpCommentViewAnimator.startAnimation()
    }
    
    @objc func handlePanOnCommentContainer(_ pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            startInteractiveTransition()
        case .changed:
            updateInteractiveTransition(fractionComplete: fractionCompleteOfPanGesture(pan))
        case .cancelled, .ended, .failed, .possible:
            continueInteractiveTransition()
        }
    }
    
    func fractionCompleteOfPanGesture(_ pan: UIPanGestureRecognizer) -> CGFloat {
        let sign: CGFloat = slideUpCommentViewAnimator.isReversed ? 1 : -1
        return sign * pan.translation(in: view).y / InteractiveSlideUpCommentContainerView.contentHeight
    }
}

// MARK: - Animations

private extension InteractiveSlideUpCommentViewController {
    
    /// Starts transition if necessary and pause on pan .begin
    func startInteractiveTransition() {
        print("\(#function)")
        slideUpCommentViewAnimator.pauseAnimation()
        if slideUpCommentViewAnimator.fractionComplete > 0.5 {
            slideUpCommentViewAnimator.isReversed = !slideUpCommentViewAnimator.isReversed
            print("\(#function) reverse animation")
        }
    }
    
    /// Scrubs transition on pan .changed
    func updateInteractiveTransition(fractionComplete: CGFloat) {
        print("\(#function) fractionComplete = \(Int(fractionComplete * 100))%")
        slideUpCommentViewAnimator.fractionComplete = fractionComplete
    }
    
    /// Continues or reverse transition on pan .cancelled, .ended, .failed, .possible
    func continueInteractiveTransition() {
        print("\(#function)")
        if slideUpCommentViewAnimator.fractionComplete < 0.5 {
            slideUpCommentViewAnimator.isReversed = !slideUpCommentViewAnimator.isReversed
            print("\(#function) reverse animation")
        }
        slideUpCommentViewAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
    }
}
