//
//  AccountService.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/20/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import Foundation
import Alamofire

//MARK: Protocols
protocol RegisterUser: class {
    func RegisterUserSuccess(salonId: String)
    func RegisterUserFail(ErrorMessage:String)
}
protocol LoginUser: class {
    func LoginUserSuccess(salonData: Dictionary<String,AnyObject>)
    func LoginUserFail(ErrorMessage:String)
}
protocol CompleteRegisterUser: class {
    func CompleteRegisterUserSuccess(salonData: Dictionary<String,AnyObject>)
    func CompleteRegisterUserFail(ErrorMessage:String)
}
protocol GetInfoUser: class {
    func GetInfoUserSuccess(salonData: Dictionary<String,AnyObject>)
    func GetInfoUserFail(ErrorMessage:String)
}
protocol ForgetPasswordUser: class {
    func ForgetPasswordUserSuccess(result: String)
    func ForgetPasswordUserFail(ErrorMessage:String)
}
protocol UpdateProfileUser: class {
    func UpdateProfileUserSuccess(salonData: Dictionary<String,AnyObject>)
    func UpdateProfileUserFail(ErrorMessage:String)
}


class AccountService: NSObject{
    var serviceBase = ServiceBase()
    
    //MARK: Delegates
    weak var RegisterUserDelegate: RegisterUser?
    weak var LoginUserDelegate: LoginUser?
    weak var CompleteRegisterUserDelegate: CompleteRegisterUser?
    weak var GetInfoUserDelegate: GetInfoUser?
    weak var ForgetPasswordUserDelegate: ForgetPasswordUser?
    weak var UpdateProfileUserDelegate: UpdateProfileUser?
    
    
    
    
    //MARK Services
    func RegisterUser(name:String, email:String, password:String, mobile:String, countryId:Int, workFrom:String,workTo:String,image:String){
        let serviceURL = "\(serviceBase.BASE_URL)\(serviceBase.SignUp)"
        let params:Dictionary<String,Any> = [
            "name": name,
            "email":email,
            "password":password,
            "mobile": mobile,
            "country_id": countryId,
            "work_from": workFrom,
            "work_to": workTo,
            "img": image,
            "lang": Helper.sharedInstance.getAppLanguage()
        ]
        Alamofire.request(serviceURL, method: .post, parameters:params ,encoding: URLEncoding()).responseJSON {
            ( response ) in
            print("1: ")
            print(response)
            print("2: ")

            print(response.result)

            switch response.result {
            case .success :
                if let  res = response.result.value as? [String : Any]{
                    print("3: ")
                    print(res)
                    if let Status = res["success"] as? Bool{
                        switch Status {
                        case true :
                            print("4: ")
                            print(res["salon_id"] ?? "none")
                            if let salonId = res["salon_id"] as? Int{
                                self.RegisterUserDelegate?.RegisterUserSuccess(salonId: "\(salonId)")
                            }
                            if let StatusText = res["validation"] as? String{
                                self.RegisterUserDelegate?.RegisterUserFail(ErrorMessage: StatusText)
                            }
                            break
                        case false:
                            if let StatusText = res["validation"] as? String{
                                self.RegisterUserDelegate?.RegisterUserFail(ErrorMessage: StatusText)
                            } else{
                                self.RegisterUserDelegate?.RegisterUserFail(ErrorMessage: "Unable to register")
                            }
                            break
                        }
                    }
                }
                break
            case .failure :
                
                self.RegisterUserDelegate?.RegisterUserFail(ErrorMessage: "Unable to register-Network Error")
                break
            }
        }
    }
    func LoginUser(email:String, password:String){
        let serviceURL = "\(serviceBase.BASE_URL)\(serviceBase.Login)"
        print(serviceURL)
        let params:Dictionary<String,Any> = [
            "login_option": email,
            "password": password,
            "devicetoken": Helper.sharedInstance.getDeviceToken(),
            "devicetype": "2",
            "lang": Helper.sharedInstance.getAppLanguage()
        ]
        Alamofire.request(serviceURL, method: .post, parameters:params ,encoding: URLEncoding()).responseJSON {
            ( response ) in
            print(response)
            switch response.result {
            case .success :
                if let  res = response.result.value as? [String : Any]{
                    if let Status = res["success"] as? Bool{
                        switch Status {
                        case true :
                            if let salonData = res["salon"] as? Dictionary<String,AnyObject>{
                                self.LoginUserDelegate?.LoginUserSuccess(salonData: salonData)
                            }else{
                                if let StatusText = res["validation"] as? String{
                                    self.LoginUserDelegate?.LoginUserFail(ErrorMessage: StatusText)
                                }
                            }
                            break
                        case false:
                            if let StatusText = res["validation"] as? String{
                                self.LoginUserDelegate?.LoginUserFail(ErrorMessage: StatusText)
                            } else{
                                self.LoginUserDelegate?.LoginUserFail(ErrorMessage: "Unable to login")
                            }
                            break
                        }
                    }
                }
                break
            case .failure :
                self.RegisterUserDelegate?.RegisterUserFail(ErrorMessage: "Unable to login-Network Error")
                break
            }
        }
    }
    func CompleteRegisterUser(id:String, lat:Double,lng:Double){
        let serviceURL = "\(serviceBase.BASE_URL)\(serviceBase.CompleteRegister)"
        let params:Dictionary<String,Any> = [
            "salon_id": id,
            "lat": lat,
            "lng": lng,
            "devicetype": 2,
            "devicetoken":Helper.sharedInstance.getDeviceToken(),
            "lang": Helper.sharedInstance.getAppLanguage()
        ]
        Alamofire.request(serviceURL, method: .post, parameters:params ,encoding: URLEncoding()).responseJSON {
            ( response ) in

            switch response.result {
            case .success :
                if let  res = response.result.value as? [String : Any]{
                    if let Status = res["success"] as? Bool{
                        switch Status {
                        case true :
                            if let salonData = res["salon"] as? Dictionary<String,AnyObject>{
                                self.CompleteRegisterUserDelegate?.CompleteRegisterUserSuccess(salonData: salonData)
                            }
                            break
                        case false:
                            if let StatusText = res["validation"] as? String{
                                self.CompleteRegisterUserDelegate?.CompleteRegisterUserFail(ErrorMessage: StatusText)
                            } else{
                                self.CompleteRegisterUserDelegate?.CompleteRegisterUserFail(ErrorMessage: "Unable to login")
                            }
                            break
                        }
                    }
                }
                break
            case .failure :
                self.CompleteRegisterUserDelegate?.CompleteRegisterUserFail(ErrorMessage: "Unable to process-Network Error")
                break
            }
        }
    }
    func GetInfoUser(id:String){
        let serviceURL = "\(serviceBase.BASE_URL)\(serviceBase.UserInfo)"
        let params:Dictionary<String,Any> = [
            "salon_id": id,
            "lang": Helper.sharedInstance.getAppLanguage()
        ]
        Alamofire.request(serviceURL, method: .post, parameters:params ,encoding: URLEncoding()).responseJSON {
            ( response ) in
            
            switch response.result {
            case .success :
                if let  res = response.result.value as? [String : Any]{
                    if let Status = res["success"] as? Bool{
                        switch Status {
                        case true :
                            if let salonData = res["salon"] as? Dictionary<String,AnyObject>{
                                self.GetInfoUserDelegate?.GetInfoUserSuccess(salonData: salonData)
                            }
                            break
                        case false:
                            if let StatusText = res["validation"] as? String{
                                self.GetInfoUserDelegate?.GetInfoUserFail(ErrorMessage: StatusText)
                            } else{
                                self.GetInfoUserDelegate?.GetInfoUserFail(ErrorMessage: "Unable to login")
                            }
                            break
                        }
                    }
                }
                break
            case .failure :
                self.GetInfoUserDelegate?.GetInfoUserFail(ErrorMessage: "Unable to process-Network Error")
                break
            }
        }
    }
    func ForgetPasswordUser(email:String){
        let serviceURL = "\(serviceBase.BASE_URL)\(serviceBase.ForgetPassword)"
        let params:Dictionary<String,Any> = [
            "email": email,
            "lang": Helper.sharedInstance.getAppLanguage()
        ]
        Alamofire.request(serviceURL, method: .post, parameters:params ,encoding: URLEncoding()).responseJSON {
            ( response ) in
            
            
            switch response.result {
            case .success :
                if let  res = response.result.value as? [String : Any]{
                    if let Status = res["success"] as? Bool{
                        switch Status {
                        case true :
                            if let message = res["validation"] as? String{
                                self.ForgetPasswordUserDelegate?.ForgetPasswordUserSuccess(result: message)
                            }
                            break
                        case false:
                            if let StatusText = res["validation"] as? String{
                                self.ForgetPasswordUserDelegate?.ForgetPasswordUserFail(ErrorMessage: StatusText)
                            } else{
                                self.ForgetPasswordUserDelegate?.ForgetPasswordUserFail(ErrorMessage: "Unable to login")
                            }
                            break
                        }
                    }
                }
                break
            case .failure :
                self.ForgetPasswordUserDelegate?.ForgetPasswordUserFail(ErrorMessage: "Unable to process-Network Error")
                break
            }
        }
    }
    func UpdateProfileUser(id:Int, name:String, email:String, password:String, mobile:String, countryId:Int, workFrom:String,workTo:String,image:String,lat:Float,lng:Float){
        let serviceURL = "\(serviceBase.BASE_URL)\(serviceBase.UpdateProfile)"
        let params:Dictionary<String,Any> = [
            "salon_id":id,
            "name": name,
            "email":email,
            "password":password,
            "mobile": mobile,
            "country_id": countryId,
            "work_from": workFrom,
            "work_to": workTo,
            "lat":lat,
            "lng":lng,
            "img": image,
            "lang": Helper.sharedInstance.getAppLanguage()
        ]
        Alamofire.request(serviceURL, method: .post, parameters:params ,encoding: URLEncoding()).responseJSON {
            ( response ) in
            
            switch response.result {
            case .success :
                if let  res = response.result.value as? [String : Any]{
                    if let Status = res["success"] as? Bool{
                        switch Status {
                        case true :
                            if let salonDetails = res["salon"] as? Dictionary<String,AnyObject>{
                                self.UpdateProfileUserDelegate?.UpdateProfileUserSuccess(salonData: salonDetails)
                            }
                            break
                        case false:
                            if let StatusText = res["validation"] as? String{
                                self.UpdateProfileUserDelegate?.UpdateProfileUserFail(ErrorMessage: StatusText)
                            } else{
                                self.UpdateProfileUserDelegate?.UpdateProfileUserFail(ErrorMessage: "Unable to update profile")
                            }
                            break
                        }
                    }
                }
                break
            case .failure :
                self.UpdateProfileUserDelegate?.UpdateProfileUserFail(ErrorMessage: "Unable to process-Network Error")
                break
            }
        }
    }

}
