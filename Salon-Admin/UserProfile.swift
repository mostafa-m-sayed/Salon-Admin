//
//  UserProfile.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/20/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import Foundation

class UserProfile {
    private var _id:String!
    private var _name:String!
    private var _email:String!
    private var _country_id:String!
    private var _mobile:String!
    private var _password:String!
    private var _img:String!
    private var _work_from:String!
    private var _work_to:String!
    private var _lat:String!
    private var _lng:String!
    private var _active:String!
    private var _completed:String!
    private var _rate:String!
    private var _rate_count:String!
    private var _devicetoken:String!
    private var _devicetype:String!
    private var _open:String!
    private var _imgURL:String!
    
    
    public var id: String{
        if _id == nil {
            return ""
        }else{
            return _id
        }
    }
    public var name: String{
        if _name == nil {
            return ""
        }else{
            return _name
        }
    }
    public var email: String{
        if _email == nil {
            return ""
        }else{
            return _email
        }
    }
    public var mobile: String{
        if _mobile == nil {
            return ""
        }else{
            return _mobile
        }
    }
    public var password: String{
        if _password == nil {
            return ""
        }else{
            return _password
        }
    }
    public var img: String{
        if _img == nil {
            return ""
        }else{
            return _img
        }
    }
    public var imgURL: String{
        if _imgURL == nil {
            return ""
        }else{
            return _imgURL
        }
    }
    public var work_from: String{
        if _work_from == nil {
            return ""
        }else{
            return _work_from
        }
    }
    public var work_to: String{
        if _work_to == nil {
            return ""
        }else{
            return _work_to
        }
    }
    public var lat: String{
        if _lat == nil {
            return ""
        }else{
            return _lat
        }
    }
    public var lng: String{
        if _lng == nil {
            return ""
        }else{
            return _lng
        }
    }
    public var active: String{
        if _active == nil {
            return ""
        }else{
            return _active
        }
    }
    public var completed: String{
        if _completed == nil {
            return ""
        }else{
            return _completed
        }
    }
    public var rate: String{
        if _rate == nil {
            return ""
        }else{
            return _rate
        }
    }
    public var rate_count: String{
        if _rate_count == nil {
            return ""
        }else{
            return _rate_count
        }
    }
    public var countryId: String{
        if _rate_count == nil {
            return ""
        }else{
            return _country_id
        }
    }
    public var devicetoken: String{
        if _devicetoken == nil {
            return ""
        }else{
            return _devicetoken
        }
    }
    public var devicetype: String{
        if _devicetype == nil {
            return ""
        }else{
            return _devicetype
        }
    }
    public var open: String{
        if _open == nil {
            return ""
        }else{
            return _open
        }
    }
    init(name:String,email:String,mobile:String,password:String,countryCode:String) {
        _name = name
        _email = email
        _mobile = mobile
        _password = password
        _country_id=countryCode
    }
    init(id:String,name:String,email:String,mobile:String) {
        _name = name
        _email = email
        _mobile = mobile
        _password = password
        _id = id
    }//For Helpers
    init(salonData:Dictionary<String,AnyObject>) {
        if let id = salonData["id"] as? String{
            _id = id
        }
        if let name = salonData["name"] as? String{
            _name = name
        }
        if let email = salonData["email"] as? String{
            _email = email
        }
        if let country_id = salonData["country_id"] as? String{
            _country_id = country_id
        }
        if let mobile = salonData["mobile"] as? String{
            _mobile = mobile
        }
        if let password = salonData["password"] as? String{
            _password = password
        }
        if let img = salonData["img"] as? String{
            _imgURL = img
        }
        if let work_from = salonData["work_from"] as? String{
            _work_from = work_from
        }
        if let work_to = salonData["work_to"] as? String{
            _work_to = work_to
        }
        if let lat = salonData["lat"] as? String{
            _lat = lat
        }
        if let lng = salonData["lng"] as? String{
            _lng = lng
        }
        if let active = salonData["active"] as? String{
            _active = active
        }
        if let completed = salonData["completed"] as? String{
            _completed = completed
        }
        if let rate = salonData["rate"] as? String{
            _rate = rate
        }
        if let rate_count = salonData["rate_count"] as? String{
            _rate_count = rate_count
        }
        if let devicetoken = salonData["devicetoken"] as? String{
            _devicetoken = devicetoken
        }
        if let devicetype = salonData["devicetype"] as? String{
            _devicetype = devicetype
        }
        if let open = salonData["open"] as? String{
            _open = open
        }
    }
    func addMapCords(lat:String,lng:String){
        _lat = lat
        _lng=lng
    }
    func addProfilePic(imageData:String) {
        _img = imageData
    }
    func addWorkingHours(from:String, to:String){
        _work_from = from
        _work_to = to
    }
    func addUserID(userID:String) {
        _id=userID
    }
}
