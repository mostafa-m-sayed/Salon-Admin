//
//  RegisterVC.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/18/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import CountryPicker

class RegisterVC: UIViewController, CountryPickerDelegate {

    @IBOutlet weak var txtName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtCountryCode: UITextField!
    @IBOutlet weak var viewCountryCode: UIView!
    
    @IBOutlet weak var pickerCode: CountryPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTextFields()
        initNavigationBar()
        
        //get corrent country
        let locale = Locale.current
        let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String?
        //init Picker
        pickerCode.countryPickerDelegate = self
        pickerCode.showPhoneNumbers = true
        pickerCode.setCountry(code!)
        addGesture()
    }
    
    func showCountryPicker(_ sender:UITapGestureRecognizer){
       pickerCode.isHidden = false
    }
    
    @IBAction func btnContinue_Click(_ sender: Any) {
//        if txtPassword.text == ""{
//            alert(message: "Password is empty", buttonMessage: "")
//            return
//        }
//        if txtName.text == ""{
//            alert(message: "Name is empty", buttonMessage: "")
//            return
//        }
//        if txtEmail.text == ""{
//            alert(message: "Email is empty", buttonMessage: "")
//            return
//        }
//        if txtMobile.text == ""{
//            alert(message: "Mobile is empty", buttonMessage: "")
//            return
//        }
//        if txtCountryCode.text == ""{
//            alert(message: "Country Code is empty", buttonMessage: "")
//            return
//        }
        let mobile = "\(txtCountryCode!.text!)\(txtMobile!.text!)"
        let userDetails = UserProfile(name: txtName.text!, email: txtEmail.text!, mobile: mobile, password: txtPassword.text!)
        
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "CompleteRegisterVC") as? CompleteRegisterVC
        nextVC?.userDetails = userDetails
        self.navigationController?.pushViewController(nextVC!, animated: true)

    }
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        //pick up anythink
        pickerCode.isHidden = true
        txtCountryCode.text = phoneCode
    }
    
    @IBAction func btnBack_Click(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func initTextFields(){
        let floatingTextColor = UIColor.gray
        
        txtName.placeholder = "Salon Name/Beauty Expert"
        txtName.selectedTitleColor = floatingTextColor
        //txtName.title = "Enter Salon Name or Beauty Expert Name"  Uncomment to change title
        
        txtEmail.placeholder = "Email Address"
        txtEmail.selectedTitleColor = floatingTextColor
        //txtEmail.title = "Enter Email Address"  Uncomment to change title
        
        txtPassword.placeholder = "Password"
        txtPassword.selectedTitleColor = floatingTextColor
        //txtEmail.title = "Enter Password"  Uncomment to change title
        }

    func initNavigationBar(){
        self.navigationItem.title = "Register"
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb:0xF5CFF3)
        self.navigationController?.navigationBar.tintColor =  UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    func addGesture(){
        let registerClick = UITapGestureRecognizer(target: self, action: #selector (self.showCountryPicker(_:)))
        viewCountryCode.addGestureRecognizer(registerClick)
    }

}
