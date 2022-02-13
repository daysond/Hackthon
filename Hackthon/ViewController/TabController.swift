//
//  TabController.swift
//  Hackthon
//
//  Created by Dayson Dong on 2022-02-12.
//

import UIKit

class MainTabController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        
        let home = UINavigationController(rootViewController: HomeViewController()) 
        home.tabBarItem = UITabBarItem(title: "HOME", image: UIImage(named: "tab1"), tag: 0)
        
        
        let recycle101 = RecycleViewController()
        recycle101.tabBarItem = UITabBarItem(title: "RECYCLE 101", image: UIImage(named: "tab2"), tag: 1)
        
        viewControllers = [home, recycle101]
        
        
    }
    
}
