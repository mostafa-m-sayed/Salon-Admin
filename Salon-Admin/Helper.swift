//
//  Helper.swift
//  Laundry
//
//  Created by Mostafa on 8/5/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import Foundation

class Helper {
    
    static let sharedInstance = Helper()
    
    //MARK: User Presistance
    //    private var _userDetails : User!
    let defaults = UserDefaults.standard
        var UserDetails: UserProfile! {
            if let salonId = defaults.object(forKey: "ID") as? String,let email = defaults.string(forKey: "Email"), let name = defaults.string(forKey: "Name"),let number = defaults.string(forKey: "Number") {
                let UserData = UserProfile(id:salonId,name: name, email: email, mobile: number)
                return UserData
            }
            return nil
    }
        func saveUserData(userData:UserProfile){
            defaults.set(userData.id, forKey: "ID")
            defaults.set(userData.email, forKey: "Email")
            defaults.set(userData.name, forKey: "Name")
            defaults.set(userData.mobile, forKey: "Number")
            defaults.set(userData.completed, forKey: "Complete")
        }
    //    func updateProfile(address: String, number:String){
    //        defaults.set(number, forKey: "Number")
    //        defaults.set(address, forKey: "Address")
    //    }
    //    func clearUserData() {
    //        defaults.removeObject(forKey: "ID")
    //        defaults.removeObject(forKey: "Email")
    //        defaults.removeObject(forKey: "Name")
    //        defaults.removeObject(forKey: "Type")
    //        defaults.removeObject(forKey: "TypeText")
    //        defaults.removeObject(forKey: "Remember")
    //        defaults.removeObject(forKey: "Number")
    //        defaults.removeObject(forKey: "Address")
    //    }
    
    func storeAppLanguage(lang: String){
        defaults.set(lang, forKey: "Lang")
    }
    func getAppLanguage()-> String{
        if let lang = defaults.string(forKey: "Lang"){
            return lang
        }
        return ""
    }
    func storeDeviceToken(DToken: String){
        defaults.set(DToken, forKey: "DToken")
    }
    func getDeviceToken()-> String{
        if let token = defaults.string(forKey: "DToken"){
            return token
        }
        return "none"
    }

}
