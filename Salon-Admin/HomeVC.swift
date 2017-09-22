//
//  HomeVC.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/16/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let usr =  Helper.sharedInstance.UserDetails{
            if usr.id != "" {
                let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "MainPageVC") as? MainPageVC
                self.navigationController?.pushViewController(nextVC!, animated: true)

            }
        }
    }
    
    
    
    
    //MARK Events
    @IBAction func btnEnglish_Click(_ sender: Any) {
        Helper.sharedInstance.storeAppLanguage(lang: "en")
        
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        self.navigationController?.pushViewController(nextVC!, animated: true)
    
    }
    @IBAction func btnArabic_Click(_ sender: Any) {
        Helper.sharedInstance.storeAppLanguage(lang: "ar")
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        self.navigationController?.pushViewController(nextVC!, animated: true)

    }
}

