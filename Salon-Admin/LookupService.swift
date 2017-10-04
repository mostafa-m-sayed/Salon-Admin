//
//  LookupService.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/29/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import Foundation
import Alamofire

//MARK: Protocols
protocol GetAppInfo: class {
    func GetAppInfoSuccess(Info: Dictionary<String,AnyObject>)
    func GetAppInfoFail(ErrorMessage:String)
}

class LookupService: NSObject{
    var serviceBase = ServiceBase()
    
    //MARK: Delegates
    weak var GetAppInfoDelegate: GetAppInfo?
    
    //MARK Services
    func GetAppInfo(){
        let serviceURL = "\(serviceBase.BASE_URL)\(serviceBase.GetAppInfo)"
        print(serviceURL)
        let params:Dictionary<String,Any> = [
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
                            if let appInfo = res["main_setting"] as? Dictionary<String,AnyObject>{
                                self.GetAppInfoDelegate?.GetAppInfoSuccess(Info: appInfo)
                            }else{
                                if let StatusText = res["validation"] as? String{
                                    self.GetAppInfoDelegate?.GetAppInfoFail(ErrorMessage: StatusText)
                                }
                            }
                            break
                        case false:
                            if let StatusText = res["validation"] as? String{
                                self.GetAppInfoDelegate?.GetAppInfoFail(ErrorMessage: StatusText)
                            } else{
                                self.GetAppInfoDelegate?.GetAppInfoFail(ErrorMessage: "Unable to login")
                            }
                            break
                        }
                    }
                }
                break
            case .failure :
                self.GetAppInfoDelegate?.GetAppInfoFail(ErrorMessage: "Unable to login-Network Error")
                break
            }
        }
    }
}
