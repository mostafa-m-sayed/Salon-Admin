//
//  ForgetPasswordVC.swift
//  Salon-Admin
//
//  Created by Mostafa on 10/4/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
class ForgetPasswordVC: UIViewController,ForgetPasswordUser {

    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!

    var accountService: AccountService = AccountService()
    var viewActivitySmall : SHActivityView?

    override func viewDidLoad() {
        super.viewDidLoad()
        initTextFields()
        accountService.ForgetPasswordUserDelegate = self
    }
    @IBAction func btnSend_Click(_ sender: Any) {
        if txtEmail.text == ""{
            alert(message: NSLocalizedString("Email", comment: ""), buttonMessage: NSLocalizedString("OK", comment: ""))
        }
        showLoader()
        accountService.ForgetPasswordUser(email: txtEmail.text!)
    }
    func ForgetPasswordUserSuccess(result: String){
        viewActivitySmall?.dismissAndStopAnimation()
        let alert =  UIAlertController(title: result
            , message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:NSLocalizedString("OK", comment: ""), style: .default, handler: { (action : UIAlertAction) in
            let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
            self.navigationController?.pushViewController(nextVC!, animated: true)
            }))
        self.present(alert, animated: true, completion: nil)
    }
    func ForgetPasswordUserFail(ErrorMessage:String){
        viewActivitySmall?.dismissAndStopAnimation()
        print(ErrorMessage)
        alert(message: ErrorMessage, buttonMessage:NSLocalizedString("OK", comment: ""))
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    func initTextFields(){
        let floatingTextColor = UIColor.gray
        
        txtEmail.placeholder = NSLocalizedString("Email", comment: "")
        txtEmail.selectedTitleColor = floatingTextColor
        //txtUserName.title = "Enter Phone number or Email Address"  Uncomment to change title
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
