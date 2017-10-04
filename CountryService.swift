//
//  service.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/30/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import Foundation
import Alamofire

//MARK: Protocols
protocol GetCountries: class {
    func GetCountriesSuccess(countries: [Dictionary<String,AnyObject>])
    func GetCountriesFail(ErrorMessage:String)
}

class CountryService: NSObject{
    
    
    //MARK: Delegates
    weak var GetCountriesDelegate: GetCountries?
    
    //MARK Services
    func GetCountries(){
        let serviceURL = "http://salonapp.net/admin/webservice/salon/list_country"
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
                            if let countries = res["data"] as? [Dictionary<String,AnyObject>]{
                                self.GetCountriesDelegate?.GetCountriesSuccess(countries: countries)
                            }else{
                                if let StatusText = res["validation"] as? String{
                                    self.GetCountriesDelegate?.GetCountriesFail(ErrorMessage: StatusText)
                                }
                            }
                            break
                        case false:
                            if let StatusText = res["validation"] as? String{
                                self.GetCountriesDelegate?.GetCountriesFail(ErrorMessage: StatusText)
                            } else{
                                self.GetCountriesDelegate?.GetCountriesFail(ErrorMessage: "Unable to login")
                            }
                            break
                        }
                    }
                }
                break
            case .failure :
                self.GetCountriesDelegate?.GetCountriesFail(ErrorMessage: "Unable to login-Network Error")
                break
            }
        }
    }
}
