//
//  Service.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/23/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import Foundation

class Service{
    private var _id:String!
    private var _price:String!
    private var _currency:String!
    private var _subcategoryName:String!
    private var _service_name:String!
    private var _service_Ename:String!
    
    public var id:String{
        if _id == nil {
            return ""
        }else{
            return _id
        }
    }
    public var price:String{
        if _price == nil {
            return ""
        }else{
            return _price
        }
    }
    public var currency:String{
        if _currency == nil {
            return ""
        }else{
            return _currency
        }
    }
    public var subcategoryName:String{
        if _subcategoryName == nil {
            return ""
        }else{
            return _subcategoryName
        }
    }
    public var service_name:String{
        if _service_name == nil {
            return ""
        }else{
            return _service_name
        }
    }
    public var service_Ename:String{
        if _service_Ename == nil {
            return ""
        }else{
            return _service_Ename
        }
    }
    
    init(serviceData:Dictionary<String,AnyObject>) {
        if let id = serviceData["id"] as? String{
            _id = id
        }
        if let price = serviceData["price"] as? String{
            _price = price
        }
        if let currency = serviceData["currency"] as? String{
            _currency = currency
        }
        if let subcategoryName = serviceData["sub_category_name"] as? String{
            _subcategoryName = subcategoryName
        }
        if let service_name = serviceData["service_name"] as? String{
            _service_name = service_name
        }
    }

}
