//
//  RegisterVC.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/18/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit
import NKVPhonePicker
import SkyFloatingLabelTextField

class RegisterVC: UIViewController {
    
    @IBOutlet weak var txtCountryCode: NKVPhonePickerTextField!
    
    @IBOutlet weak var txtName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMobile: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTextFields()
        initNavigationBar()
        initPicker()
        
        //get corrent country
        //let locale = Locale.current
        //let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String?
    }
    
    @IBAction func btnContinue_Click(_ sender: Any) {
        print(txtCountryCode.code)
        
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
        
        let userDetails = UserProfile(name: txtName.text!, email: txtEmail.text!, mobile: txtMobile.text!, password: txtPassword.text!,countryCode:txtCountryCode.code)
        
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
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb:0xF5CFF3)
        self.navigationController?.navigationBar.tintColor =  UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    func initPicker(){
        txtCountryCode.favoriteCountriesLocaleIdentifiers = ["RU", "ER", "JM"]
        txtCountryCode.phonePickerDelegate =  self
        let country = Country.countryBy(countryCode: "EG")
        txtCountryCode.currentSelectedCountry = country
        //txtCountryCode.text = "+20"
    }
    
}
