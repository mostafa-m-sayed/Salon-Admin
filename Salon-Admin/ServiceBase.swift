//
//  ServiceBase.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/20/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import Foundation

class ServiceBase: NSObject{
    let BASE_URL = "http://salonapp.net/admin/webservice/salon/"
    //MARK: Account
    
    let SignUp = "register"
    let Login = "login"
    let CompleteRegister = "complete_register"
    let UserInfo = "user_information"
    let ForgetPassword = "forgetpassword"
    let UpdateProfile = "profile"
    let Logout = "logout"
    //MARK: Images
    let AddImage = "add_img"
    let DeleteImage = "delete_img"
    
    //MARK: Service
    
    let GetSalonSubCategories = "list_salon_sub_category"
    let GetSalonServices = "list_salon_service"
    
    let AddSalonSubcategory = "add_salon_sub_category_ios"
    let DeleteSalonSubCategory = "delete_salon_sub_category"
    let AddSalonService = "add_service"
    let EditSalonService = "edit_service"
    let DeleteSalonService = "delete_service"
    let UpdateSalonService = "edit_service"
    
    let GetAvailableCategoriesWithSubcategories = "list_category_and_inner"
    let GetAppInfo = "list_mainsetting"
    
    //MARK: Reservations
    let CurrentOrders = "current_orders"
    let FinishedOrders = "finished_orders"
    let OrderDetails = "get_order"

    let ChangeOrderStatus = "change_order_status"
    
    //MARK: Notifications
    let GetNotifications = "salon_notification"
    let AcceptOrder = "accept_order"
    let CloseOrder = "close_order"
}
