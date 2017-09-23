//
//  Image.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/23/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import Foundation
class Image {
    private var _id:String!
    private var _salonId:String!
    private var _img:String!
    
    public var id:String{
        if _id == nil {
            return ""
        }else{
            return _id
        }
    }
    public var salonId:String{
        if _salonId == nil {
            return ""
        }else{
            return _salonId
        }
    }
    public var img:String{
        if _img == nil {
            return ""
        }else{
            return _img
        }
    }
    
    init(imgData:Dictionary<String,AnyObject>) {
        if let id = imgData["id"] as? String{
            _id = id
        }
        if let salonId = imgData["salon_id"] as? String{
            _salonId = salonId
        }
        if let img = imgData["img"] as? String{
            _img = img
        }
    }
}
