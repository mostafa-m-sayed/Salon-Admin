//
//  NotificationService.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/29/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import Foundation
import Alamofire

//MARK: Protocols
protocol GetNotifications: class {
    func GetNotificationsSuccess(Notifications: [Dictionary<String,AnyObject>])
    func GetNotificationsFail(ErrorMessage:String)
}
protocol AcceptOrder: class {
    func AcceptOrderSuccess(Message: String)
    func AcceptOrderFail(ErrorMessage:String)
}
protocol RejectOrder: class {
    func RejectOrderSuccess(Message: String)
    func RejectOrderFail(ErrorMessage:String)
}

class NotificationService: NSObject{
    var serviceBase = ServiceBase()
    
    //MARK: Delegates
    weak var GetNotificationsDelegate: GetNotifications?
    weak var AcceptOrderDelegate: AcceptOrder?
    weak var RejectOrderDelegate: RejectOrder?
    
    //MARK Services
    func GetNotifications(salonId:String){
        let serviceURL = "\(serviceBase.BASE_URL)\(serviceBase.GetNotifications)"
        print(serviceURL)
        let params:Dictionary<String,Any> = [
            "salon_id":salonId,
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
                            if let notifications = res["data"] as? [Dictionary<String,AnyObject>]{
                                self.GetNotificationsDelegate?.GetNotificationsSuccess(Notifications: notifications)
                            }else{
                                if let StatusText = res["validation"] as? String{
                                    self.GetNotificationsDelegate?.GetNotificationsFail(ErrorMessage: StatusText)
                                }
                            }
                            break
                        case false:
                            if let StatusText = res["validation"] as? String{
                                self.GetNotificationsDelegate?.GetNotificationsFail(ErrorMessage: StatusText)
                            } else{
                                self.GetNotificationsDelegate?.GetNotificationsFail(ErrorMessage: "Error")
                            }
                            break
                        }
                    }
                }
                break
            case .failure :
                self.GetNotificationsDelegate?.GetNotificationsFail(ErrorMessage: "failed-Network Error")
                break
            }
        }
    }
    
    func AcceptOrder(salonId:String,orderId:String){
        let serviceURL = "\(serviceBase.BASE_URL)\(serviceBase.AcceptOrder)"
        print(serviceURL)
        let params:Dictionary<String,Any> = [
            "salon_id":salonId,
            "order_id":orderId,
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
                            if let message = res["validation"] as? String{
                                self.AcceptOrderDelegate?.AcceptOrderSuccess(Message: message)
                            }else{
                                if let StatusText = res["validation"] as? String{
                                    self.AcceptOrderDelegate?.AcceptOrderFail(ErrorMessage: StatusText)
                                }
                            }
                            break
                        case false:
                            if let StatusText = res["validation"] as? String{
                                self.AcceptOrderDelegate?.AcceptOrderFail(ErrorMessage: StatusText)
                            } else{
                                self.AcceptOrderDelegate?.AcceptOrderFail(ErrorMessage: "Error")
                            }
                            break
                        }
                    }
                }
                break
            case .failure :
                self.AcceptOrderDelegate?.AcceptOrderFail(ErrorMessage: "failed-Network Error")
                break
            }
        }
    }
    func RejectOrder(salonId:String,orderId:String){
        let serviceURL = "\(serviceBase.BASE_URL)\(serviceBase.AcceptOrder)"
        print(serviceURL)
        let params:Dictionary<String,Any> = [
            "salon_id":salonId,
            "order_id":orderId,
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
                            if let message = res["validation"] as? String{
                                self.RejectOrderDelegate?.RejectOrderSuccess(Message: message)
                            }else{
                                if let StatusText = res["validation"] as? String{
                                    self.RejectOrderDelegate?.RejectOrderFail(ErrorMessage: StatusText)
                                }
                            }
                            break
                        case false:
                            if let StatusText = res["validation"] as? String{
                                self.RejectOrderDelegate?.RejectOrderFail(ErrorMessage: StatusText)
                            } else{
                                self.RejectOrderDelegate?.RejectOrderFail(ErrorMessage: "Error")
                            }
                            break
                        }
                    }
                }
                break
            case .failure :
                self.RejectOrderDelegate?.RejectOrderFail(ErrorMessage: "failed-Network Error")
                break
            }
        }
    }


}
