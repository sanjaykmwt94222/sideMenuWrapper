//
//  MainViewController.swift
//  DemoSideMenu
//
//  Created by cl-macmini-92 on 08/02/18.
//  Copyright © 2018 cl-macmini-92. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

   lazy var slideTransitioningDelegate: SlideInPresentationManager = SlideInPresentationManager()

    @IBOutlet weak var containerView: UIView!

    @IBAction func menuButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "segToMenuVC", sender: nil)
    }

    var activeController: UIViewController? {
        didSet {
            remove(asChildViewController: oldValue)
            updateActiveViewController()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Menus.sharedInstance = Menus()
        activeController = Menus.sharedInstance?.getMenuItems().first
    }

    public func updateActiveViewController() {
        guard let activeVC = self.activeController, let index = Menus.sharedInstance?.getMenuItems().index(of: activeVC) else {
            return
        }
        Menus.sharedInstance?.selectedIndex = index
        self.addChildViewController(activeVC) // Add Child View Controller
        activeVC.view.frame = self.containerView.bounds
        self.containerView.addSubview(activeVC.view) // Add Child View as SubView
        activeVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        activeVC.didMove(toParentViewController: self) // Notify child View controller
        self.view.layoutIfNeeded()

    }

    public func remove(asChildViewController viewController: UIViewController?) {
        viewController?.willMove(toParentViewController: nil) // Notify Child View Controller
        // Remove child view from superview
        viewController?.view.removeFromSuperview()
        viewController?.removeFromParentViewController()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? MenuViewController {
              slideTransitioningDelegate.direction = .left(.overlay)
             controller.transitioningDelegate = slideTransitioningDelegate
             controller.modalPresentationStyle = .custom
        }
    }

}
