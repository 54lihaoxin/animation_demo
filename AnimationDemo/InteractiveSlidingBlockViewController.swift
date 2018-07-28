//
//  InteractiveSlidingBlockViewController.swift
//  AnimationDemo
//
//  Created by Haoxin Li on 7/8/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import UIKit

final class InteractiveSlidingBlockViewController: UIViewController {

    @IBOutlet fileprivate weak var slidingBar: UIView!
    @IBOutlet fileprivate weak var slidingShape: UIView!
    @IBOutlet fileprivate weak var slidingShapeCenterXConstraint: NSLayoutConstraint!
    fileprivate var animator: UIViewPropertyAnimator?
    fileprivate var progressWhenInterrupted: CGFloat = 0
    private lazy var slidingShapePan = UIPanGestureRecognizer(target: self, action: #selector(handlePanOnSlidingShape(_:)))
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    init() {
        super.init(nibName: InteractiveSlidingBlockViewController.className, bundle: nil)
        title = "WWDC 2017 - 230.1"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slidingShape.addGestureRecognizer(slidingShapePan)
    }
}

// MARK: - private

private extension InteractiveSlidingBlockViewController {
    
    @IBAction func resetSlidingShape(_ sender: Any) {
        animator = nil
        progressWhenInterrupted = 0
        slidingShapeCenterXConstraint.constant = 0
        view.layoutIfNeeded()
    }
    
    @objc func handlePanOnSlidingShape(_ pan: UIPanGestureRecognizer) {
        // https://developer.apple.com/videos/play/wwdc2017/230/ ~ 4:15
        switch pan.state {
        case .began:
            let animator = animateTransitionIfNeeded(duration: 2)
            self.animator = animator
            animator.pauseAnimation()
            progressWhenInterrupted = max(0, animator.fractionComplete - (slidingShape.bounds.width / 2 / slidingBar.bounds.width))
        case .changed:
            guard let animator = animator else {
                assertionFailure()
                return
            }
            let translation = pan.translation(in: slidingShape)
            animator.fractionComplete = translation.x / slidingBar.bounds.width + progressWhenInterrupted
        case .cancelled, .ended, .failed, .possible:
            guard let animator = animator else {
                assertionFailure()
                return
            }
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
    func animateTransitionIfNeeded(duration: TimeInterval) -> UIViewPropertyAnimator {
        if let animator = animator {
            return animator
        } else {
            let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut, animations: { [weak self] in
                guard let this = self else {
                    return
                }
                this.slidingShapeCenterXConstraint.constant = this.slidingBar.bounds.width
                this.view.layoutIfNeeded()
            })
            return animator
        }
    }
}
