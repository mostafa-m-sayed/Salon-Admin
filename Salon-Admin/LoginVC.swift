//
//  LoginVC.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/18/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginVC: UIViewController,LoginUser {

    //MARK: IBOutlets
    @IBOutlet weak var txtUserName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var viewForgotPassword: UIView!
    @IBOutlet weak var viewNewUser: UIView!
   
    var accountService: AccountService = AccountService()
    var viewActivitySmall : SHActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTextFields()
        addGesture()
        accountService.LoginUserDelegate = self
    }
    
    func LoginUserSuccess(salonData: Dictionary<String,AnyObject>){
        viewActivitySmall?.dismissAndStopAnimation()
        let userDetails = UserProfile(salonData: salonData)
        Helper.sharedInstance.saveUserData(userData: userDetails)
        if userDetails.completed == "0"{
            let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "RegisterLocationVC") as? RegisterLocationVC
            nextVC?.userID = userDetails.id
            self.navigationController?.pushViewController(nextVC!, animated: true)
        }else{
            let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "MainTBC") as? MainTBC
            self.navigationController?.pushViewController(nextVC!, animated: true)
            Helper.sharedInstance.storeDeviceToken(DToken: userDetails.devicetoken)
        }
        print(salonData)
    }
    func LoginUserFail(ErrorMessage:String){
        viewActivitySmall?.dismissAndStopAnimation()
        print(ErrorMessage)
        alert(message: ErrorMessage, buttonMessage:NSLocalizedString("OK", comment: ""))

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func btnLogin_Click(_ sender: Any) {
        if txtUserName.text == ""{
            alert(message: NSLocalizedString("Email", comment: ""), buttonMessage: NSLocalizedString("OK", comment: ""))
            return
        }
        if txtPassword.text == ""{
            alert(message: NSLocalizedString("Password", comment: ""), buttonMessage: NSLocalizedString("OK", comment: ""))
            return
        }
        showLoader()
        accountService.LoginUser(email: txtUserName.text!, password: txtPassword.text!)
    }
    func showRegisterView(_ sender:UITapGestureRecognizer){
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "RegisterVC") as? RegisterVC
        self.navigationController?.pushViewController(nextVC!, animated: true)
    }
    
    func showForgotPasswordView(_ sender:UITapGestureRecognizer) {
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "ForgetPasswordVC") as? ForgetPasswordVC
        self.navigationController?.pushViewController(nextVC!, animated: true)    }
    
    //MARK: Helpers
    func addGesture(){
        let registerClick = UITapGestureRecognizer(target: self, action: #selector (self.showRegisterView(_:)))
        viewNewUser.addGestureRecognizer(registerClick)
        
        let forgotPasswordClick = UITapGestureRecognizer(target: self, action: #selector (self.showForgotPasswordView(_:)))
        viewForgotPassword.addGestureRecognizer(forgotPasswordClick)
    }
    func initTextFields(){
        let floatingTextColor = UIColor.gray
        
        txtUserName.placeholder = NSLocalizedString("Phone Or Email", comment: "")
        txtUserName.selectedTitleColor = floatingTextColor
        //txtUserName.title = "Enter Phone number or Email Address"  Uncomment to change title
        
        txtPassword.placeholder = NSLocalizedString("Password", comment: "")
        txtPassword.selectedTitleColor = floatingTextColor
        //txtPassword.title = "Enter Password"  Uncomment to change title
    }
    func showLoader(){
        viewActivitySmall = SHActivityView.init()
        viewActivitySmall?.spinnerSize = .kSHSpinnerSizeSmall
        viewActivitySmall?.spinnerColor = UIColor(rgb: 0x522D6A)
        self.view.addSubview(viewActivitySmall!)
        viewActivitySmall?.showAndStartAnimate()
        viewActivitySmall?.center = CGPoint(x: (self.view?.frame.size.width)!/2, y: (self.view?.frame.size.height)!/2)
    }

}
