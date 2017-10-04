//
//  RegisterVC.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/18/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class RegisterVC: UIViewController,CodeDropDownDelegate {
    
    @IBOutlet weak var viewCode: CodeDropDown!
    var selectCountry : Country!

    @IBOutlet weak var txtName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMobile: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTextFields()
        initNavigationBar()
        viewCode.delegate = self
    }
    func codeDropDown(_ codeDropDown: CodeDropDown, didSelectItem country: Country) {
        selectCountry = country
    }

    @IBAction func btnContinue_Click(_ sender: Any) {
        if txtPassword.text == ""{
            alert(message: NSLocalizedString("Null Password", comment: ""), buttonMessage: NSLocalizedString("OK", comment: ""))
            return
        }
        if txtName.text == ""{
            alert(message: NSLocalizedString("Null Name", comment: ""), buttonMessage: NSLocalizedString("OK", comment: ""))
            return
        }
        if txtEmail.text == ""{
            alert(message: NSLocalizedString("Null Email", comment: ""), buttonMessage: NSLocalizedString("OK", comment: ""))
            return
        }
        if txtMobile.text == ""{
            alert(message: NSLocalizedString("Null Mobile", comment: ""), buttonMessage: NSLocalizedString("OK", comment: ""))
            return
        }
        if selectCountry == nil{
            alert(message: NSLocalizedString("Null Country", comment: ""), buttonMessage: NSLocalizedString("OK", comment: ""))
            return
        }
        
        let userDetails = UserProfile(name: txtName.text!, email: txtEmail.text!, mobile: txtMobile.text!, password: txtPassword.text!,countryCode:selectCountry.id)
        
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "CompleteRegisterVC") as? CompleteRegisterVC
        nextVC?.userDetails = userDetails
        self.navigationController?.pushViewController(nextVC!, animated: true)
        
    }
    @IBAction func btnBack_Click(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func initTextFields(){
        let floatingTextColor = UIColor.gray
        
        txtName.placeholder = NSLocalizedString("Name", comment: "")
        txtName.selectedTitleColor = floatingTextColor
        //txtName.title = "Enter Salon Name or Beauty Expert Name"  Uncomment to change title
        
        txtEmail.placeholder = NSLocalizedString("Email", comment: "")
        txtEmail.selectedTitleColor = floatingTextColor
        //txtEmail.title = "Enter Email Address"  Uncomment to change title
        
        txtPassword.placeholder = NSLocalizedString("Password", comment: "")
        txtPassword.selectedTitleColor = floatingTextColor
        //txtEmail.title = "Enter Password"  Uncomment to change title
    }
    
    func initNavigationBar(){
        self.navigationItem.title = NSLocalizedString("Register", comment: "")
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb:0xf5c1f0)
        self.navigationController?.navigationBar.tintColor =  UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.setHidesBackButton(true, animated: false)
        if Helper.sharedInstance.getAppLanguage() == "ar"{
            if navigationItem.leftBarButtonItem != nil{
                navigationItem.rightBarButtonItem = navigationItem.leftBarButtonItem
                navigationItem.leftBarButtonItem = nil
            }
        }

    }
    
}
