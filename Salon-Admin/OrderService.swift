//
//  OrderService.swift
//  Salon-Admin
//
//  Created by Mostafa on 10/1/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import Foundation

class OrderService{
    
    private var _serviceId:String!
    private var _serviceName:String!
    private var _serviceCurrency:String!
    private var _orderId:String!
    private var _servicePrice:String!
    private var _personNumber:String!
    
    public var serviceId:String{
        if _serviceId == nil {
            return ""
        }else{
            return _serviceId
        }
    }
    public var serviceName:String{
        if _serviceName == nil {
            return ""
        }else{
            return _serviceName
        }
    }
    public var serviceCurrency:String{
        if _serviceCurrency == nil {
            return ""
        }else{
            return _serviceCurrency
        }
    }
    public var orderId:String{
        if _orderId == nil {
            return ""
        }else{
            return _orderId
        }
    }
    public var servicePrice:String{
        if _servicePrice == nil {
            return ""
        }else{
            return _servicePrice
        }
    }
    public var personNumber:String{
        if _personNumber == nil {
            return ""
        }else{
            return _personNumber
        }
    }
    
    init(orderService:Dictionary<String,AnyObject>) {
        if let serviceId = orderService["service_id"] as? String{
            _serviceId = serviceId
        }
        if let serviceName = orderService["service_name"] as? String{
            _serviceName = serviceName
        }
        if let serviceCurrency = orderService["serivce_currency"] as? String{
            _serviceCurrency = serviceCurrency
        }
        if let orderId = orderService["order_id"] as? String{
            _orderId = orderId
        }
        if let servicePrice = orderService["price"] as? String{
            _servicePrice = servicePrice
        }
        if let personNumber = orderService["person_num"] as? String{
            _personNumber = personNumber
        }
    }
    
}
