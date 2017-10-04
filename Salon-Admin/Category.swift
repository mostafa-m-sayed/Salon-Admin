//
//  Category.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/25/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import Foundation

class Category {
    private var _id:String!
    private var _categoryName:String!
    private var _subcategories:[Subcategory]!
    public var id:String{
        if _id == nil {
            return ""
        }else{
            return _id
        }
    }
    public var categoryName:String{
        if _categoryName == nil {
            return ""
        }else{
            return _categoryName
        }
    }
    public var subcategories:[Subcategory]{
        if _subcategories == nil {
            return [Subcategory]()
        }else{
            return _subcategories
        }
    }
    
    init(CategoryWithSubcategories:Dictionary<String,AnyObject>) {
        if let id = CategoryWithSubcategories["id"] as? String{
            _id = id
        }
        if let categoryName = CategoryWithSubcategories["category_name"] as? String{
            _categoryName = categoryName
        }
        if let subcategories = CategoryWithSubcategories["sub_category"] as? [Dictionary<String,AnyObject>]{
            if subcategories.count>0 {
                var serializedSubcategories = [Subcategory]()
                for subcat in subcategories {
                    let serializedSubcat = Subcategory(subcategory: subcat)
                    serializedSubcategories.append(serializedSubcat)
                }
                _subcategories = serializedSubcategories
            }
        }
    }
}
