//
//  Reservation.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/29/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import Foundation

class Reservation{
    
    private var _id: String!
    private var _reservationDay: String!
    private var _reservationTime: String!
    private var _city: String!
    private var _district: String!
    private var _street: String!
    private var _home: String!
    private var _name: String!
    private var _mobile: String!
    private var _status: String!
    private var _services: [OrderService]!
    private var _client: Client!
    public var id:String{
        if _id == nil {
            return ""
        }else{
            return _id
        }
    }
    public var reservationDay:String{
        if _reservationDay == nil {
            return ""
        }else{
            return _reservationDay
        }
    }
    public var reservationTime:String{
        if _reservationTime == nil {
            return ""
        }else{
            return _reservationTime
        }
    }
    public var city:String{
        if _city == nil {
            return ""
        }else{
            return _city
        }
    }
    public var district:String{
        if _district == nil {
            return ""
        }else{
            return _district
        }
    }
    public var street:String{
        if _street == nil {
            return ""
        }else{
            return _street
        }
    }
    public var home:String{
        if _home == nil {
            return ""
        }else{
            return _home
        }
    }
    public var name:String{
        if _name == nil {
            return ""
        }else{
            return _name
        }
    }
    public var mobile:String{
        if _mobile == nil {
            return ""
        }else{
            return _mobile
        }
    }
    public var services:[OrderService]{
        if _services == nil {
            return [OrderService]()
        }else{
            return _services
        }
    }
    public var client:Client{
        if _client == nil {
            return Client()
        }else{
            return _client
        }
    }
    public var status:String{
        if _status == nil {
            return ""
        }else{
            return _status
        }
    }
    init(reservation: Dictionary<String,AnyObject>) {
        if let id = reservation["id"] as? String{
            _id = id
        }
        if let reservationDay = reservation["reservation_day"] as? String{
            _reservationDay = reservationDay
        }
        if let reservationTime = reservation["reservation_time"] as? String{
            _reservationTime = reservationTime
        }
        if let city = reservation["city_id"] as? String{
            _city = city
        }
        if let district = reservation["district_id"] as? String{
            _district = district
        }
        if let street = reservation["street"] as? String{
            _street = street
        }
        if let home = reservation["home"] as? String{
            _home = home
        }
        if let name = reservation["client_name"] as? String{
            _name = name
        }
        if let mobile = reservation["mobile"] as? String{
            _mobile = mobile
        }
        if let status = reservation["status"] as? String{
            _status = status
        }
        if let services = reservation["detail"] as? [Dictionary<String,AnyObject>]{
            if services.count>0{
            _services = [OrderService]()
                for srvc in services {
                    _services.append(OrderService(orderService: srvc))
                }
            }
        }
        if let client = reservation["client"] as? Dictionary<String,AnyObject>{
            _client = Client(clientData: client)
        }
    }
}
