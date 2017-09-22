//
//  ServiceBase.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/20/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import Foundation

class ServiceBase: NSObject{
    let BASE_URL = "http://salonapp.net/admin/webservice/salon/"
    //MARK: Account
    
    let SignUp = "register"
    let Login = "login"
    let CompleteRegister = "complete_register"
    let UserInfo = "user_information"
    let ForgetPassword = "forgetpassword"
    let UpdateProfile = "profile"
    
}
