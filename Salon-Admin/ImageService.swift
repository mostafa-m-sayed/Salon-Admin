//
//  ImageService.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/24/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import Foundation
import Alamofire

//MARK: Protocols
protocol AddImage: class {
    func AddImageSuccess(Message: String)
    func AddImageFail(ErrorMessage:String)
}
protocol DeleteImage: class {
    func DeleteImageSuccess(Message: String)
    func DeleteImageFail(ErrorMessage:String)
}

class ImageService: NSObject{
    var serviceBase = ServiceBase()

    //MARK: Delegates
    weak var AddImageDelegate: AddImage?
    weak var DeleteImageDelegate: DeleteImage?
    
    
    //MARK Services
    func AddImage(salonId:String, image:String){
        let serviceURL = "\(serviceBase.BASE_URL)\(serviceBase.AddImage)"
        print(serviceURL)
        let params:Dictionary<String,Any> = [
            "salon_id": salonId,
            "img": image,
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
                            if let validation = res["validation"] as? String{
                                self.AddImageDelegate?.AddImageSuccess(Message: validation)
                            }else{
                                if let StatusText = res["validation"] as? String{
                                    self.AddImageDelegate?.AddImageFail(ErrorMessage: StatusText)
                                }
                            }
                            break
                        case false:
                            if let StatusText = res["validation"] as? String{
                                self.AddImageDelegate?.AddImageFail(ErrorMessage: StatusText)
                            } else{
                                self.AddImageDelegate?.AddImageFail(ErrorMessage: "Unable to Upload")
                            }
                            break
                        }
                    }
                }
                break
            case .failure :
                self.AddImageDelegate?.AddImageFail(ErrorMessage: "Unable to Upload-Network Error")
                break
            }
        }
    }
    
    func DeleteImage(imageId:String){
        let serviceURL = "\(serviceBase.BASE_URL)\(serviceBase.DeleteImage)"
        print(serviceURL)
        let params:Dictionary<String,Any> = [
            "img_id": imageId,
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
                            if let validation = res["validation"] as? String{
                                self.DeleteImageDelegate?.DeleteImageSuccess(Message: validation)
                            }else{
                                if let StatusText = res["validation"] as? String{
                                    self.DeleteImageDelegate?.DeleteImageFail(ErrorMessage: StatusText)
                                }
                            }
                            break
                        case false:
                            if let StatusText = res["validation"] as? String{
                                self.DeleteImageDelegate?.DeleteImageFail(ErrorMessage: StatusText)
                            } else{
                                self.DeleteImageDelegate?.DeleteImageFail(ErrorMessage: "Unable to Delete")
                            }
                            break
                        }
                    }
                }
                break
            case .failure :
                self.DeleteImageDelegate?.DeleteImageFail(ErrorMessage: "Unable to Delete-Network Error")
                break
            }
        }
    }
}
