//
//  Subcategory.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/23/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import Foundation

class Subcategory {
    private var _id:String!
    private var _subcategoryId:String!
    private var _subcategoryName:String!
    private var _categoryName:String!
    private var _serviceNumber:String!
    private var _selected:Bool!
    
    public var id:String{
        if _id == nil {
            return ""
        }else{
            return _id
        }
    }
    public var subcategoryId:String{
        get{
            
            if _subcategoryId == nil {
                return ""
            }else{
                return _subcategoryId
            }
        }
        set{
            _subcategoryId = newValue
            
        }
    }
    public var subcategoryName:String{
        if _subcategoryName == nil {
            return ""
        }else{
            return _subcategoryName
            
        }
        
    }
    public var categoryName:String{
        if _categoryName == nil {
            return ""
        }else{
            return _categoryName
        }
    }
    public var serviceNumber:String{
        if _serviceNumber == nil {
            return ""
        }else{
            return _serviceNumber
        }
    }
    public var selected:Bool{
        get{
            if _selected == nil {
                return false
            }else{
                return _selected
            }
        }
        set{
            _selected = newValue
        }
        
    }
    init(Id:String, SubcatId:String) {
        _id=id
        _subcategoryId = SubcatId
    }
    init(subcategory:Dictionary<String,AnyObject>) {
        if let id = subcategory["id"] as? String{
            _id = id
        }
        if let subcategoryId = subcategory["sub_category_id"] as? String{
            _subcategoryId = subcategoryId
        }
        if let subcategoryName = subcategory["sub_category_name"] as? String{
            _subcategoryName = subcategoryName
        }
        if let categoryName = subcategory["category_name"] as? String{
            _categoryName = categoryName
        }
        if let serviceNumber = subcategory["service_number"] as? String{
            _serviceNumber = serviceNumber
        }
    }
}
