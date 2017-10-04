//
//  AppInfo.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/29/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import Foundation

class AppInfo {
    
    private var _aboutUs: String!
    private var _contactUs: String!
    private var _terms: String!
    
    public var aboutUs:String{
        if _aboutUs == nil {
            return ""
        }else{
            return _aboutUs
        }
    }
    public var contactUs:String{
        if _contactUs == nil {
            return ""
        }else{
            return _contactUs
        }
    }
    public var terms:String{
        if _terms == nil {
            return ""
        }else{
            return _terms
        }
    }
    
    init(AppInfo: Dictionary<String,AnyObject>) {
        if let abboutUs = AppInfo["about_app"] as? String{
            _aboutUs = abboutUs
        }
        if let contactUs = AppInfo["contact_us"] as? String{
            _contactUs = contactUs
        }
        if let terms = AppInfo["rules"] as? String{
            _terms = terms
        }
    }

}
