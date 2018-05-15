//
//  SlideInPresentationManager.swift
//  MedalCount
//
//  Created by Dheeraj on 31/12/17.
//  Copyright © 2017 Ron Kliffer. All rights reserved.
//

import UIKit

enum PresentationStyle {
   case overlay
   case reveal
   case ssa
}

enum PresentationDirection: Equatable {
  case left(PresentationStyle)
  case right
  case top
  case bottom
}

func ==(lhs: PresentationDirection, rhs: PresentationDirection) -> Bool {
  switch (lhs, rhs) {
  case let (.left(a), .left(b)):
    return a == b
  default:
    return false
  }
}

class SlideInPresentationManager: NSObject {

  var direction = PresentationDirection.left(.overlay)
  var disableCompactHeight = false
  var menuWidth: CGFloat = 0.8
  
}

extension SlideInPresentationManager: UIViewControllerTransitioningDelegate {
  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    if self.direction == .left(.ssa) {
      return nil
    }
    let presentedViewController = SlideInPresentationController(presentedViewController: presented, presenting: presenting, direction: direction, menuWidth: menuWidth)
    presentedViewController.delegate = self
    return presentedViewController
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return SlideInPresentationAnimator(direction: direction, isPresentation: false, menuWidth: menuWidth)
  }
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return SlideInPresentationAnimator(direction: direction, isPresentation: true, menuWidth: menuWidth)
  }
}

extension SlideInPresentationManager: UIAdaptivePresentationControllerDelegate {
  func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
    if traitCollection.verticalSizeClass == .compact && disableCompactHeight {
       return .overFullScreen
    } else {
      return .none
    }
  }
  
  func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
    guard style == .overFullScreen else { return nil }
    
    return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RotateViewController")
  }
}

