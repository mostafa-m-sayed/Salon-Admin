//
//  ServiceService.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/23/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import Foundation
import Alamofire

//MARK: Protocols

protocol GetSalonSubCategories: class {
    func GetSalonSubCategoriesSuccess(salonSubCategories: [Dictionary<String,AnyObject>])
    func GetSalonSubCategoriesFail(ErrorMessage:String)
}
protocol GetSalonServices: class {
    func GetSalonServicesSuccess(salonServices: [Dictionary<String,AnyObject>])
    func GetSalonServicesFail(ErrorMessage:String)
}

protocol GetAvailableCatsWithSubs: class {//CategoriesWithSubCategories
    func GetAvailableCatsWithSubsSuccess(CategoriesWithSubcategories: [Dictionary<String,AnyObject>])
    func GetAvailableCatsWithSubsFail(ErrorMessage:String)
}

protocol AddSubcategory: class {
    func AddSubcategorySuccess(message: String)
    func AddSubcategoryFail(ErrorMessage:String)
}

protocol DeleteSubcategory: class {
    func DeleteSubcategorySuccess(message: String)
    func DeleteSubcategoryFail(ErrorMessage:String)
}

protocol AddService: class {
    func AddServiceSuccess(message: String)
    func AddServiceFail(ErrorMessage:String)
}

protocol DeleteService: class {
    func DeleteServiceSuccess(message: String)
    func DeleteServiceFail(ErrorMessage:String)
}

protocol UpdateService: class {
    func UpdateServiceSuccess(message: String)
    func UpdateServiceFail(ErrorMessage:String)
}

class ServiceService: NSObject{
    var serviceBase = ServiceBase()
    
    //MARK: Delegates
    weak var GetSalonSubCategoriesDelegate: GetSalonSubCategories?
    weak var GetSalonServicesDelegate: GetSalonServices?
    weak var GetAvailableCatsWithSubsDelegate: GetAvailableCatsWithSubs?
    weak var AddSubcategoryDelegate: AddSubcategory?
    weak var DeleteSubcategoryDelegate: DeleteSubcategory?
    weak var AddServiceDelegate: AddService?
    weak var DeleteServiceDelegate: DeleteService?
    weak var UpdateServiceDelegate: UpdateService?
    
    //MARK: Services
    func GetSalonSubCategories(salonId:String){
        let serviceURL = "\(serviceBase.BASE_URL)\(serviceBase.GetSalonSubCategories)"
        print(serviceURL)
        let params:Dictionary<String,Any> = [
            "salon_id": salonId,
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
                            if let subcategories = res["data"] as? [Dictionary<String,AnyObject>]{
                                self.GetSalonSubCategoriesDelegate?.GetSalonSubCategoriesSuccess(salonSubCategories: subcategories)
                            }else{
                                if let StatusText = res["validation"] as? String{
                                    self.GetSalonSubCategoriesDelegate?.GetSalonSubCategoriesFail(ErrorMessage: StatusText)
                                }
                            }
                            break
                        case false:
                            if let StatusText = res["validation"] as? String{
                                self.GetSalonSubCategoriesDelegate?.GetSalonSubCategoriesFail(ErrorMessage: StatusText)
                            } else{
                                self.GetSalonSubCategoriesDelegate?.GetSalonSubCategoriesFail(ErrorMessage: "Unable to Delete")
                            }
                            break
                        }
                    }
                }
                break
            case .failure :
                self.GetSalonSubCategoriesDelegate?.GetSalonSubCategoriesFail(ErrorMessage: "Unable to get subcategories-Network Error")
                break
            }
        }
    }
    
    func GetSalonServices(salonId:String,subcategoryId:String){
        let serviceURL = "\(serviceBase.BASE_URL)\(serviceBase.GetSalonServices)"
        print(serviceURL)
        let params:Dictionary<String,Any> = [
            "salon_id": salonId,
            "sub_category_id": subcategoryId,
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
                            if let services = res["data"] as? [Dictionary<String,AnyObject>]{
                                self.GetSalonServicesDelegate?.GetSalonServicesSuccess(salonServices: services)
                            }else{
                                if let StatusText = res["validation"] as? String{
                                    self.GetSalonServicesDelegate?.GetSalonServicesFail(ErrorMessage: StatusText)
                                }
                            }
                            break
                        case false:
                            if let StatusText = res["validation"] as? String{
                                self.GetSalonServicesDelegate?.GetSalonServicesFail(ErrorMessage: StatusText)
                            } else{
                                self.GetSalonServicesDelegate?.GetSalonServicesFail(ErrorMessage: "Unable to get")
                            }
                            break
                        }
                    }
                }
                break
            case .failure :
                self.GetSalonServicesDelegate?.GetSalonServicesFail(ErrorMessage: "Unable to get services-Network Error")
                break
            }
        }
    }
    
    func GetAvailableCatsWithSubs(){
        let serviceURL = "\(serviceBase.BASE_URL)\(serviceBase.GetAvailableCategoriesWithSubcategories)"
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
                            if let catsWithSubs = res["data"] as? [Dictionary<String,AnyObject>]{
                                self.GetAvailableCatsWithSubsDelegate?.GetAvailableCatsWithSubsSuccess(CategoriesWithSubcategories: catsWithSubs)
                            }else{
                                if let StatusText = res["validation"] as? String{
                                    self.GetAvailableCatsWithSubsDelegate?.GetAvailableCatsWithSubsFail(ErrorMessage: StatusText)
                                }
                            }
                            break
                        case false:
                            if let StatusText = res["validation"] as? String{
                                self.GetAvailableCatsWithSubsDelegate?.GetAvailableCatsWithSubsFail(ErrorMessage: StatusText)
                            } else{
                                self.GetAvailableCatsWithSubsDelegate?.GetAvailableCatsWithSubsFail(ErrorMessage: "Unable to Get Subcategories")
                            }
                            break
                        }
                    }
                }
                break
            case .failure :
                self.GetAvailableCatsWithSubsDelegate?.GetAvailableCatsWithSubsFail(ErrorMessage: "Unable to get subcategories-Network Error")
                break
            }
        }
    }
    
    func AddSubcategory(salonId:String,subcategories:[String]){
        let serviceURL = "\(serviceBase.BASE_URL)\(serviceBase.AddSalonSubcategory)"
        var subs: [Dictionary<String,String>] = []
        var uselessDictionary = Dictionary<String,[Dictionary<String,String>]>()
        for subcat in subcategories {
            let sub:Dictionary<String,String> = ["sub_category_id": subcat]
            subs.append(sub)
        }
        
        uselessDictionary["sub_category"] = subs
        let data = try! JSONSerialization.data(withJSONObject: uselessDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = String(data: data,encoding: .ascii)!
        let params:Dictionary<String,Any> = [
            "salon_id": salonId,
            "sub_category": jsonString,
            "lang": Helper.sharedInstance.getAppLanguage()
        ]
               // var jsonString = ""
       // var jsonData : Data!
//        if let theJSONData = try? JSONSerialization.data(
//            withJSONObject: params,
//            options: []) {
//            jsonData = theJSONData
//            jsonString = String(data: theJSONData,
//                                     encoding: .ascii)!
//            print("JSON string = \(jsonString)")
//        }
       // let data = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        //let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        //if let json = json {
          //  print(json)
        //}
        //var request = URLRequest(url: URL(string:serviceURL)!)
        //request.httpMethod = HTTPMethod.post.rawValue
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.httpBody = json!.data(using: String.Encoding.utf8.rawValue);
        
        print(params)
        Alamofire.request(serviceURL, method: .post, parameters:params ,encoding: URLEncoding()).responseJSON{
            ( response ) in
            print(response)
            switch response.result {
            case .success :
                if let  res = response.result.value as? [String : Any]{
                    if let Status = res["success"] as? Bool{
                        switch Status {
                        case true :
                            if let message = res["validation"] as? String{
                                self.AddSubcategoryDelegate?.AddSubcategorySuccess(message: message)
                            }else{
                                if let StatusText = res["validation"] as? String{
                                    self.AddSubcategoryDelegate?.AddSubcategoryFail(ErrorMessage: StatusText)
                                }
                            }
                            break
                        case false:
                            if let StatusText = res["validation"] as? String{
                                self.AddSubcategoryDelegate?.AddSubcategoryFail(ErrorMessage: StatusText)
                            } else{
                                self.AddSubcategoryDelegate?.AddSubcategoryFail(ErrorMessage: "Unable to get")
                            }
                            break
                        }
                    }
                }
                break
            case .failure :
                self.AddSubcategoryDelegate?.AddSubcategoryFail(ErrorMessage: "Unable to get services-Network Error")
                break
            }
        }
    }
    
    func DeleteSubcategory(id:String){
        let serviceURL = "\(serviceBase.BASE_URL)\(serviceBase.DeleteSalonSubCategory)"
        let params:Dictionary<String,Any> = [
            "id": id,
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
                            if let services = res["validation"] as? String{
                                self.DeleteSubcategoryDelegate?.DeleteSubcategorySuccess(message: services)
                            }else{
                                if let StatusText = res["validation"] as? String{
                                    self.DeleteSubcategoryDelegate?.DeleteSubcategoryFail(ErrorMessage: StatusText)
                                }
                            }
                            break
                        case false:
                            if let StatusText = res["validation"] as? String{
                                self.DeleteSubcategoryDelegate?.DeleteSubcategoryFail(ErrorMessage: StatusText)
                            } else{
                                self.DeleteSubcategoryDelegate?.DeleteSubcategoryFail(ErrorMessage: "Unable to get")
                            }
                            break
                        }
                    }
                }
                break
            case .failure :
                self.DeleteSubcategoryDelegate?.DeleteSubcategoryFail(ErrorMessage: "Unable to get services-Network Error")
                break
            }
        }
        
    }
    
    func AddService(salonId:String,subcatId:String,serviceName:String,serviceEName:String,price:String,currency:String){
        let serviceURL = "\(serviceBase.BASE_URL)\(serviceBase.AddSalonService)"
        let params:Dictionary<String,Any> = [
            "salon_id": salonId,
            "sub_category_id":subcatId,
            "service_name_ar":serviceName,
            "service_name_en":serviceEName,
            "price":price,
            "currency":currency,
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
                            if let services = res["validation"] as? String{
                                self.AddServiceDelegate?.AddServiceSuccess(message: services)
                            }else{
                                if let StatusText = res["validation"] as? String{
                                    self.AddServiceDelegate?.AddServiceFail(ErrorMessage: StatusText)
                                }
                            }
                            break
                        case false:
                            if let StatusText = res["validation"] as? String{
                                self.AddServiceDelegate?.AddServiceFail(ErrorMessage: StatusText)
                            } else{
                                self.AddServiceDelegate?.AddServiceFail(ErrorMessage: "Unable to add")
                            }
                            break
                        }
                    }
                }
                break
            case .failure :
                self.AddServiceDelegate?.AddServiceFail(ErrorMessage: "Unable to add service-Network Error")
                break
            }
        }
        
    }
    
    func DeleteService(serviceId:String){
        let serviceURL = "\(serviceBase.BASE_URL)\(serviceBase.DeleteSalonService)"
        let params:Dictionary<String,Any> = [
            "service_id": serviceId,
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
                            if let services = res["validation"] as? String{
                                self.DeleteServiceDelegate?.DeleteServiceSuccess(message: services)
                            }else{
                                if let StatusText = res["validation"] as? String{
                                    self.DeleteServiceDelegate?.DeleteServiceFail(ErrorMessage: StatusText)
                                }
                            }
                            break
                        case false:
                            if let StatusText = res["validation"] as? String{
                                self.DeleteServiceDelegate?.DeleteServiceFail(ErrorMessage: StatusText)
                            } else{
                                self.DeleteServiceDelegate?.DeleteServiceFail(ErrorMessage: "Unable to delete")
                            }
                            break
                        }
                    }
                }
                break
            case .failure :
                self.DeleteServiceDelegate?.DeleteServiceFail(ErrorMessage: "Unable to delete service-Network Error")
                break
            }
        }
        
    }
    
    func UpdateService(serviceId:String,salonId:String,subcatId:String,serviceName:String,serviceEName:String,price:String,currency:String){
        let serviceURL = "\(serviceBase.BASE_URL)\(serviceBase.UpdateSalonService)"
        let params:Dictionary<String,Any> = [
            "service_id": serviceId,
            "salon_id": salonId,
            "sub_category_id":subcatId,
            "service_name_ar":serviceName,
            "service_name_en":serviceEName,
            "price":price,
            "currency":currency,
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
                            if let services = res["validation"] as? String{
                                self.UpdateServiceDelegate?.UpdateServiceSuccess(message: services)
                            }else{
                                if let StatusText = res["validation"] as? String{
                                    self.UpdateServiceDelegate?.UpdateServiceFail(ErrorMessage: StatusText)
                                }
                            }
                            break
                        case false:
                            if let StatusText = res["validation"] as? String{
                                self.UpdateServiceDelegate?.UpdateServiceFail(ErrorMessage: StatusText)
                            } else{
                                self.UpdateServiceDelegate?.UpdateServiceFail(ErrorMessage: "Unable to add")
                            }
                            break
                        }
                    }
                }
                break
            case .failure :
                self.UpdateServiceDelegate?.UpdateServiceFail(ErrorMessage: "Unable to add service-Network Error")
                break
            }
        }
        
    }
}

