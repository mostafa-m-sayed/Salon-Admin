//
//  Helper.swift
//  Laundry
//
//  Created by Mostafa on 8/5/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import Foundation
import UIKit
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
        func clearUserData() {
            defaults.removeObject(forKey: "ID")
            defaults.removeObject(forKey: "Email")
            defaults.removeObject(forKey: "Name")
            defaults.removeObject(forKey: "Number")
            defaults.removeObject(forKey: "DToken")
            defaults.removeObject(forKey: "Complete")
            //defaults.removeObject(forKey: "Lang")
        }
    
    func storeAppLanguage(lang: String){
        defaults.set(lang, forKey: "Lang")
    }
    func clearLanguage(){
        defaults.removeObject(forKey: "Lang")
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
    func getStatusName(statusId:String) ->String{
        switch statusId {
        case "1":
            return NSLocalizedString("Accepted", comment: "")
        case "2":
            return NSLocalizedString("Processing", comment: "")
        case "3":
            return NSLocalizedString("Completed", comment: "")
        default:
            return ""
        }
    }
    func convertTimeFormat(time24:String) ->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: time24)
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date!)
    }
    func getTimeFromDate(date:Date) -> String{
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        //let seconds = calendar.component(.second, from: date)
        return "\(hour):\(minutes)"
        //print("hours = \(hour):\(minutes):\(seconds)")
    }
    func makeCall(phoneNumber:String){
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    func sendMessage(phoneNumber:String){
        if let url = URL(string: "sms://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
