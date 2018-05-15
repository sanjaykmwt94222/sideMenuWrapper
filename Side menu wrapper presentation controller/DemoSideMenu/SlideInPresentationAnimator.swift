//
//  SlideInPresentationAnimator.swift
//  MedalCount
//
//  Created by Dheeraj on 31/12/17.
//

import UIKit

class SlideInPresentationAnimator: NSObject {
  // MARK: - Properties
  let direction: PresentationDirection
  let snapShotNumber = 12345 // To maintain the container view
  let isPresentation: Bool
  var menuWidth: CGFloat
  
  init(direction: PresentationDirection, isPresentation: Bool, menuWidth: CGFloat) {
    self.direction = direction
    self.isPresentation = isPresentation
    self.menuWidth = menuWidth
    super.init()
  }
}

extension SlideInPresentationAnimator: UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    if self.direction == .left(.reveal) || self.direction == .left(.ssa) {
      revealTransition(using: transitionContext, isPresenting: isPresentation)
      return
    }
    let key = isPresentation ? UITransitionContextViewControllerKey.to : UITransitionContextViewControllerKey.from

    let controller = transitionContext.viewController(forKey: key)!

    if isPresentation {
      transitionContext.containerView.addSubview(controller.view)
    }

    let presentedFrame = transitionContext.finalFrame(for: controller)
    var dismissedFrame = presentedFrame

    switch direction {
    case .left:
      dismissedFrame.origin.x = -presentedFrame.width
    case .right:
      dismissedFrame.origin.x = transitionContext.containerView.frame.size.width
    case .top:
      dismissedFrame.origin.y = -presentedFrame.height
    case .bottom:
      dismissedFrame.origin.y = transitionContext.containerView.frame.size.height
   
    }

    let initialFrame = isPresentation ? dismissedFrame : presentedFrame
    let finalFrame = isPresentation ? presentedFrame : dismissedFrame

    let animationDuration = transitionDuration(using: transitionContext)
    controller.view.frame = initialFrame
    UIView.animate(withDuration: animationDuration, animations: {
      controller.view.frame = finalFrame
    }) { finished in
      transitionContext.completeTransition(finished)
    }
  }
  
  func revealTransition(using transitionContext: UIViewControllerContextTransitioning, isPresenting: Bool) {
    
    guard let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) else {
      return
    }
    let containerView = transitionContext.containerView
    let snapshot = fromVC.view.snapshotView(afterScreenUpdates: false)
     snapshot?.tag = self.snapShotNumber
    if isPresenting {
      containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
      
      fromVC.view.isHidden = true
      snapshot?.isUserInteractionEnabled = false
      snapshot?.layer.shadowOpacity = 0.7
      
      containerView.insertSubview(snapshot!, aboveSubview: toVC.view)
      UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
        snapshot?.center.x += UIScreen.main.bounds.width * self.menuWidth

        if self.direction == .left(.ssa) {
          snapshot?.layer.cornerRadius = 0.5
          snapshot?.layer.masksToBounds = true
          snapshot?.transform = CGAffineTransform(scaleX: 1, y: 0.75)
        }
        
      }) { (_) in
        fromVC.view.isHidden = false
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      }
    } else {
       let snapshotView = containerView.viewWithTag(self.snapShotNumber)
      UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
        if self.direction == .left(.reveal) {
           snapshotView?.frame = CGRect(origin: CGPoint.zero, size: UIScreen.main.bounds.size)
        } else {
           snapshot?.transform = CGAffineTransform.identity
        }
 
      }) { (_) in
        let didTransitionComplete = !transitionContext.transitionWasCancelled
        if didTransitionComplete {
          snapshotView?.removeFromSuperview()
        }
        transitionContext.completeTransition(didTransitionComplete)
      }
    }
  }
  
}


