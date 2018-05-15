//
//  Menus.swift
//  Side Menu
//
//  Created by Dheeraj on 15/07/17.
//

import UIKit
enum CellType: Int {
    case task
    case completedTasks
    case myLocations
    case help
    case logout
    case profile
}

class Menus: NSObject {

    private var menuItems: [MenuItems] = [MenuItems]()
    
    static var sharedInstance: Menus?
    var selectedIndex: Int = 0
    var cellType: CellType = .task

    override init() {
    
        let menuItem1 = MenuItems(viewControllerId: "RedViewController", storyBoardName: "Main", title: "Red")
        let menuItem2 = MenuItems(viewControllerId: "YellowViewController", storyBoardName: "Main", title: "Yellow")
        let menuItem3 = MenuItems(viewControllerId: "GreenViewController", storyBoardName: "Main", title: "Green")

        self.menuItems = [menuItem1, menuItem2, menuItem3]
			
    }
    
    func getMenuItems() -> [UIViewController] {
        return self.menuItems.flatMap({ return $0.viewController })
    }
    var selectedViewController: UIViewController? {
        guard selectedIndex < menuItems.count else {
            return nil
        }
        return self.menuItems[selectedIndex].viewController
    }
    
    var selectedCellType: CellType? {
        guard selectedIndex < menuItems.count else {
            return nil
        }
        return CellType(rawValue: selectedIndex)
    }
    
}

struct MenuItems {
    
    var viewController: UIViewController?
    
    init(viewControllerId: String, storyBoardName: String, title: String) {
        let viewController = UIStoryboard(name: storyBoardName, bundle: nil).instantiateViewController(withIdentifier: viewControllerId)
        self.viewController = viewController
        self.viewController?.title = title
    }

}
