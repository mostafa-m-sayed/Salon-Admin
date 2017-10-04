//
//  Country.swift
//  CountryPhoneCodePicker
//
//  Created by Ragaie alfy on 9/25/17.
//  Copyright © 2017 Ragaie alfy. All rights reserved.
//

import UIKit

class Country: NSObject {
    var id:String!
    var name : String!
    var dial_code : String!
    var code : String!
    var format : String!
    var img:String!
    
    
    
    override init(){
        super.init()
    }
    init(countryCode: String, phoneExtension: String, formatPattern: String = "###################", name : String) {
        self.code = countryCode
        self.dial_code = phoneExtension
        self.format = formatPattern
        self.name = name
        //self.id = id
    }
    init(country:Dictionary<String,AnyObject>) {
        if let id = country["id"] as? String{
            self.id = id
        }
        if let code = country["code"] as? String{
            self.dial_code = code
        }
        if let img = country["img"] as? String{
            self.img = img
        }
    }
    
}
