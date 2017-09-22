//
//  MainPageVC.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/21/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class MainPageVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func btnProfile_Click(_ sender: Any) {
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "MyProfileVC") as? MyProfileVC
        self.navigationController?.pushViewController(nextVC!, animated: true)

        
    }

}
