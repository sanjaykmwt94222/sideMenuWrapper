//
//  MenuViewController.swift
//  DemoSideMenu
//
//  Created by cl-macmini-92 on 08/02/18.
//  Copyright © 2018 cl-macmini-92. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var controllersNamesArray: [String] = ["Red", "Yellow", "Green"]
    fileprivate var viewControllerArray: [UIViewController] {
        get {
            return (Menus.sharedInstance?.getMenuItems()) ?? []
        }
        set {}
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

     func navigateToViewController(_ controller: UIViewController?) {
        if self.presentingViewController is UINavigationController {
            guard let parentVC = self.presentingViewController as? UINavigationController, let parentController = parentVC.viewControllers.last as? MainViewController else {
                return
            }

            guard parentController.activeController?.classForCoder != controller?.classForCoder else {
                return
            }
            
            parentController.activeController = controller
        }
    }

}
extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "CELL")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "CELL")
        }
       cell.textLabel?.text = controllersNamesArray[indexPath.row]
        return cell
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Menus.sharedInstance?.selectedIndex = indexPath.row
        dismiss(animated: true, completion: nil)
        self.navigateToViewController(viewControllerArray[indexPath.row])
    }
}
