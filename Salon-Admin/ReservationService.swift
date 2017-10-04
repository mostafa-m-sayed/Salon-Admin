//
//  ReservationService.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/29/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import Foundation
import Alamofire

//MARK: Protocols
protocol GetFinishedReservations: class {
    func GetFinishedReservationsSuccess(Reservations: [Dictionary<String,AnyObject>])
    func GetFinishedReservationsFail(ErrorMessage:String)
}
protocol GetCurrentReservations: class {
    func GetCurrentReservationsSuccess(Reservations: [Dictionary<String,AnyObject>])
    func GetCurrentReservationsFail(ErrorMessage:String)
}
protocol ChangeOrderStatus: class {
    func ChangeOrderStatusSuccess(Message: String)
    func ChangeOrderStatusFail(ErrorMessage:String)
}
protocol GetReservationDetails: class {
    func GetReservationDetailsSuccess(ReservationDetails: Dictionary<String,AnyObject>)
    func GetReservationDetailsFail(ErrorMessage:String)
}

class ReservationService: NSObject{
    var serviceBase = ServiceBase()
    
    //MARK: Delegates
    weak var GetFinishedReservationsDelegate: GetFinishedReservations?
    weak var GetCurrentReservationsDelegate: GetCurrentReservations?
    weak var ChangeOrderStatusDelegate: ChangeOrderStatus?
    weak var GetReservationDetailsDelegate: GetReservationDetails?

    //MARK Services
    func GetFinishedReservations(salonId:String){
        let serviceURL = "\(serviceBase.BASE_URL)\(serviceBase.FinishedOrders)"
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
                            if let reservations = res["data"] as? [Dictionary<String,AnyObject>]{
                                self.GetFinishedReservationsDelegate?.GetFinishedReservationsSuccess(Reservations: reservations)
                            }else{
                                if let StatusText = res["validation"] as? String{
                                    self.GetFinishedReservationsDelegate?.GetFinishedReservationsFail(ErrorMessage: StatusText)
                                }
                            }
                            break
                        case false:
                            if let StatusText = res["validation"] as? String{
                                self.GetFinishedReservationsDelegate?.GetFinishedReservationsFail(ErrorMessage: StatusText)
                            } else{
                                self.GetFinishedReservationsDelegate?.GetFinishedReservationsFail(ErrorMessage: "Error")
                            }
                            break
                        }
                    }
                }
                break
            case .failure :
                self.GetFinishedReservationsDelegate?.GetFinishedReservationsFail(ErrorMessage: "failed-Network Error")
                break
            }
        }
    }
    
    func GetCurrentReservations(salonId:String){
        let serviceURL = "\(serviceBase.BASE_URL)\(serviceBase.CurrentOrders)"
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
                            if let reservations = res["data"] as? [Dictionary<String,AnyObject>]{
                                self.GetCurrentReservationsDelegate?.GetCurrentReservationsSuccess(Reservations: reservations)
                            }else{
                                if let StatusText = res["validation"] as? String{
                                    self.GetCurrentReservationsDelegate?.GetCurrentReservationsFail(ErrorMessage: StatusText)
                                }
                            }
                            break
                        case false:
                            if let StatusText = res["validation"] as? String{
                                self.GetCurrentReservationsDelegate?.GetCurrentReservationsFail(ErrorMessage: StatusText)
                            } else{
                                self.GetCurrentReservationsDelegate?.GetCurrentReservationsFail(ErrorMessage: "Error")
                            }
                            break
                        }
                    }
                }
                break
            case .failure :
                self.GetCurrentReservationsDelegate?.GetCurrentReservationsFail(ErrorMessage: "failed-Network Error")
                break
            }
        }
    }

    func ChangeOrderStatus(salonId:String, orderId:String, statusId:String){
        let serviceURL = "\(serviceBase.BASE_URL)\(serviceBase.ChangeOrderStatus)"
        print(serviceURL)
        let params:Dictionary<String,Any> = [
            "salon_id":salonId,
            "order_id":orderId,
            "status":statusId,
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
                                self.ChangeOrderStatusDelegate?.ChangeOrderStatusSuccess(Message: message)
                            }else{
                                if let StatusText = res["validation"] as? String{
                                    self.ChangeOrderStatusDelegate?.ChangeOrderStatusFail(ErrorMessage: StatusText)
                                }
                            }
                            break
                        case false:
                            if let StatusText = res["validation"] as? String{
                                self.ChangeOrderStatusDelegate?.ChangeOrderStatusFail(ErrorMessage: StatusText)
                            } else{
                                self.ChangeOrderStatusDelegate?.ChangeOrderStatusFail(ErrorMessage: "Error")
                            }
                            break
                        }
                    }
                }
                break
            case .failure :
                self.ChangeOrderStatusDelegate?.ChangeOrderStatusFail(ErrorMessage: "failed-Network Error")
                break
            }
        }
    }

    func GetReservationDetails(orderId:String){
        let serviceURL = "\(serviceBase.BASE_URL)\(serviceBase.OrderDetails)"
        print(serviceURL)
        let params:Dictionary<String,Any> = [
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
                            if let reservations = res["data"] as? Dictionary<String,AnyObject>{
                                self.GetReservationDetailsDelegate?.GetReservationDetailsSuccess(ReservationDetails: reservations)
                            }else{
                                if let StatusText = res["validation"] as? String{
                                    self.GetReservationDetailsDelegate?.GetReservationDetailsFail(ErrorMessage: StatusText)
                                }
                            }
                            break
                        case false:
                            if let StatusText = res["validation"] as? String{
                                self.GetReservationDetailsDelegate?.GetReservationDetailsFail(ErrorMessage: StatusText)
                            } else{
                                self.GetReservationDetailsDelegate?.GetReservationDetailsFail(ErrorMessage: "Error")
                            }
                            break
                        }
                    }
                }
                break
            case .failure :
                self.GetReservationDetailsDelegate?.GetReservationDetailsFail(ErrorMessage: "failed-Network Error")
                break
            }
        }
    }

}
