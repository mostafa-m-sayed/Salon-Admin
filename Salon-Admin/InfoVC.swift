//
//  InfoVC.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/28/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class InfoVC: UIViewController {
    
    var pageType:Int!//1=Contact,2=About,3=Terms
    @IBOutlet weak var lblContent: UILabel!
    var pageContent:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBar()
        lblContent.text = pageContent
    }
    @IBAction func btnBack_Click(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
  
    func initNavigationBar(){
        switch pageType {
        case 1:
            self.navigationItem.title = NSLocalizedString("Contact Us", comment: "")
            break
        case 2:
            self.navigationItem.title = NSLocalizedString("About Us", comment: "")
            break
        case 3:
            self.navigationItem.title = NSLocalizedString("Terms Of Use", comment: "")
            break
        default:
            break
        }
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb:0xf5c1f0)
        self.navigationController?.navigationBar.tintColor =  UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        if Helper.sharedInstance.getAppLanguage() == "ar"{
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            if navigationItem.leftBarButtonItem != nil{
                navigationItem.rightBarButtonItem = navigationItem.leftBarButtonItem
                navigationItem.leftBarButtonItem = nil
                navigationItem.setHidesBackButton(true, animated: false)
            }
        }
        
    }
    
}
