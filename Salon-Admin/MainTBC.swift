//
//  MainTBC.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/24/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class MainTBC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initNavigationBar()
        //        let selectedColor = UIColor(red: 246.0/255.0, green: 155.0/255.0, blue: 13.0/255.0, alpha: 1.0)
        //        let unselectedColor = UIColor(red: 16.0/255.0, green: 224.0/255.0, blue: 223.0/255.0, alpha: 1.0)
        //        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: unselectedColor], for: .normal)
        //        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: selectedColor], for: .selected)
        self.selectedIndex = 3

        self.tabBar.items?[3].selectedImage = UIImage(named: "user2")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[3].image = UIImage(named: "user1")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[3].title=""//Profile
        
        
        self.tabBar.items?[2].selectedImage = UIImage(named: "list2")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[2].image = UIImage(named: "list1")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[2].title = ""//Reservations
        
        self.tabBar.items?[1].selectedImage = UIImage(named: "notifications2")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[1].image = UIImage(named: "notifications1")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[1].title = ""//Notifications
        
        self.tabBar.items?[0].selectedImage = UIImage(named: "more2")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[0].image = UIImage(named: "more1")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[0].title = ""//More
    }
    
//    func initNavigationBar(){
//        self.navigationItem.title = NSLocalizedString("My Profile", comment: "")
//        self.navigationController?.navigationBar.barTintColor = UIColor(rgb:0xf5c1f0)
//        self.navigationController?.navigationBar.tintColor =  UIColor.white
//        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
//        navigationItem.setHidesBackButton(true, animated: false)
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
//    }

}
