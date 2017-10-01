//
//  VisualEffectTransition.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/29/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

// MARK: - VisualEffectTransitionToViewProtocal
protocol VisualEffectTransitionToViewProtocal: class {
    var visualEffectView: UIVisualEffectView { get }
}

// MARK: - VisualEffectTransition
final class VisualEffectTransition: NSObject {
    
    // MARK: - Properties
    let duration: TimeInterval
    let isAppearing: Bool
    var panGestureRecognizer: UIPanGestureRecognizer?
    var transitionContext: UIViewControllerContextTransitioning?
    var startLocation: CGPoint = .zero
    weak var presentedVC: UIViewController?
    
    // MARK: - Lifecycle
    init(duration: TimeInterval = 0.5,  isAppearing: Bool, view: UIView? = nil, presentedVC: UIViewController? = nil) {
        self.duration = duration
        self.isAppearing = isAppearing
        self.presentedVC = presentedVC
        super.init()
        
        if let view = view {
            let pan = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_: )))
            view.addGestureRecognizer(pan)
        }
    }
    
    // MARK: - Actions
    @objc
    private func handlePan(_ sender: UIPanGestureRecognizer) {
        let velocity = sender.velocity(in: transitionContext?.containerView)
        let translation = sender.translation(in: sender.view)
        let location = sender.location(in: transitionContext?.containerView)
        
        let fromVC = transitionContext?.viewController(forKey: .from)
        let progress = (location.y - startLocation.y) / (sender.view?.bounds.height ?? 1.0)
        switch sender.state {
        case .began:
            startLocation = location
            presentedVC?.dismiss(animated: true)
        case .changed:
            guard(fromVC?.view.frame.origin.y ?? 0.0) + translation.y > 0.0,
                let transitionContext = transitionContext else { return }
            fromVC?.view.frame.origin.y += translation.y
            transitionContext.updateInteractiveTransition(progress)
        case .cancelled:
            endTransitionByCancelling()
            startLocation = .zero
        case .ended:
            if velocity.y > 0.5 {
                finishDismissTransition()
            }
            else {
                endTransitionByCancelling()
            }
            startLocation = .zero
        default:
            startLocation = .zero
            break
        }
        sender.setTranslation(.zero, in: sender.view)
    }
    
    private func endTransitionByCancelling(_ progress: CGFloat = 1.0) {
        guard let transitionContext = self.transitionContext else { return }
        let fromVC = transitionContext.viewController(forKey: .from)
        let fromView = fromVC?.view
        
        UIView.animate(withDuration: TimeInterval(progress) * duration, animations: {
                fromView?.frame = CGRect(x: 0.0, y: 0.0, width: transitionContext.containerView.bounds.width, height: transitionContext.containerView.bounds.height)
            }, completion: { [unowned self](_) in
                self.transitionContext?.completeTransition(false)
        })
    }
    
    fileprivate func finishDismissTransition(_ progress: CGFloat = 0.0) {
        guard let transitionContext = self.transitionContext else { return }
        let fromVC = transitionContext.viewController(forKey: .from)
        let toVC = transitionContext.viewController(forKey: .to)
        let toView = toVC?.view
        let fromView = fromVC?.view
        let containerView = transitionContext.containerView
        
        UIView.animate(withDuration: TimeInterval(1.0 - progress) * duration, animations: {
                toView?.alpha = 1.0
                toView?.frame = transitionContext.finalFrame(for: toVC!)
                var fromFrame = fromView?.frame
                fromFrame?.origin.y = containerView.frame.height
                fromView?.frame = fromFrame ?? .zero
        }, completion: { (finished) in
                fromView?.removeFromSuperview()
                toView?.isUserInteractionEnabled = true
                transitionContext.completeTransition(finished)
        })
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension VisualEffectTransition: UIViewControllerAnimatedTransitioning {
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let fromView = fromVC.view,
            let toView = toVC.view else { return }
        
        let containerView = transitionContext.containerView
        let duration = self.transitionDuration(using: transitionContext)
        
        if self.isAppearing {
            fromView.isUserInteractionEnabled = false
            
            guard let toVCVisualEffectView = toVC as? VisualEffectTransitionToViewProtocal else {
                transitionContext.completeTransition(false)
                
                return
            }
            
            let visualEffect = toVCVisualEffectView.visualEffectView.effect
            toVCVisualEffectView.visualEffectView.effect = nil
            let fromViewInitialFrame = transitionContext.initialFrame(for: fromVC)
            let toViewInitialFrame = transitionContext.finalFrame(for: toVC)
            toView.frame = toViewInitialFrame
            toView.layoutIfNeeded()
            containerView.addSubview(toView)
            toView.subviews.filter { !($0 is UIVisualEffectView) }.forEach { $0.alpha = 0.0 }
            toVCVisualEffectView.visualEffectView.subviews.forEach { $0.alpha = 0.0 }
            UIView.animate(withDuration: duration, animations: {
                toView.frame = transitionContext.finalFrame(for: toVC)
                let fromFrame = fromViewInitialFrame
                fromView.frame = fromFrame
                toVCVisualEffectView.visualEffectView.effect = visualEffect
                toView.subviews.filter { !($0 is UIVisualEffectView) }.forEach { $0.alpha = 1.0 }
                toVCVisualEffectView.visualEffectView.subviews.forEach { $0.alpha = 1.0 }
            }, completion: { (finished) in
                transitionContext.completeTransition(finished)
            })
            
        }
        else {
            finishDismissTransition()
        }
        
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
}

extension VisualEffectTransition: UIViewControllerInteractiveTransitioning {
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        if startLocation == .zero {
            finishDismissTransition()
        }
    }
}
