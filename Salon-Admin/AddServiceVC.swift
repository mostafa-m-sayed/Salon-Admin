//
//  AddServiceVC.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/27/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class AddServiceVC: UIViewController,AddService,UpdateService {
    var service:Service!
    var subcategoryId:String!
    var serviceService = ServiceService()
    
    var viewActivitySmall : SHActivityView?
    
    
    @IBOutlet weak var txtName: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtPrice: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtCurrency: SkyFloatingLabelTextField!
    @IBOutlet weak var btnSubmit: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        initTextFields()
        checkViewStatus()
        serviceService.AddServiceDelegate = self
        serviceService.UpdateServiceDelegate = self
    }
    @IBAction func btnBack_Click(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func UpdateServiceSuccess(message: String){
        viewActivitySmall?.dismissAndStopAnimation()
         _ = navigationController?.popViewController(animated: true)
    }
    func UpdateServiceFail(ErrorMessage:String){
        viewActivitySmall?.dismissAndStopAnimation()
        alert(message: ErrorMessage, buttonMessage:NSLocalizedString("OK", comment: ""))
        print(ErrorMessage)
    }
    
    
    func AddServiceSuccess(message: String){
        viewActivitySmall?.dismissAndStopAnimation()
         _ = navigationController?.popViewController(animated: true)
    }
    func AddServiceFail(ErrorMessage:String){
        viewActivitySmall?.dismissAndStopAnimation()
        alert(message: ErrorMessage, buttonMessage:NSLocalizedString("OK", comment: ""))
        print(ErrorMessage)
    }
   
    @IBAction func btnSubmit_Click(_ sender: Any) {
        let userId = Helper.sharedInstance.UserDetails.id
        if let srvc = service{
            showLoader()
            serviceService.UpdateService(serviceId: srvc.id, salonId: userId, subcatId: subcategoryId, serviceName: txtName.text!, serviceEName: txtName.text!, price: txtPrice.text!, currency: txtCurrency.text!)
        }else{
            showLoader()
            serviceService.AddService(salonId: userId, subcatId: subcategoryId, serviceName: txtName.text!, serviceEName: txtName.text!, price: txtPrice.text!, currency: txtCurrency.text!)
        }
    }
    func checkViewStatus(){
        if let srvc = service{
            btnSubmit.setTitle(NSLocalizedString("Edit", comment: ""), for: .normal)
            txtName.text = srvc.service_name
            txtPrice.text = srvc.price
            txtCurrency.text = srvc.currency
        }else{
            btnSubmit.setTitle(NSLocalizedString("Add", comment: ""), for: .normal)

        }
    }
    func initTextFields(){
        let floatingTextColor = UIColor.gray
        
        txtName.placeholder = NSLocalizedString("Service Name", comment: "")
        txtName.selectedTitleColor = floatingTextColor
        //txtName.title = "Enter Name"  Uncomment to change title
        
        txtPrice.placeholder = NSLocalizedString("Service Price", comment: "")
        txtPrice.selectedTitleColor = floatingTextColor
        //txtPrice.title = "Enter Price"  Uncomment to change title
        
        txtCurrency.placeholder = NSLocalizedString("Service Currency", comment: "")
        txtCurrency.selectedTitleColor = floatingTextColor
        //txtCurrency.title = "Enter Currency"  Uncomment to change title
    }
    func showLoader(){
        viewActivitySmall = SHActivityView.init()
        viewActivitySmall?.spinnerSize = .kSHSpinnerSizeSmall
        viewActivitySmall?.spinnerColor = UIColor(rgb: 0x522D6A)
        self.view.addSubview(viewActivitySmall!)
        viewActivitySmall?.showAndStartAnimate()
        viewActivitySmall?.center = CGPoint(x: (self.view?.frame.size.width)!/2, y: (self.view?.frame.size.height)!/2)
    }
    func initNavigationBar(){
        self.navigationItem.title = NSLocalizedString("Add Service", comment: "")
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb:0xf5c1f0)
        self.navigationController?.navigationBar.tintColor =  UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        if Helper.sharedInstance.getAppLanguage() == "ar"{
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            if navigationItem.leftBarButtonItem != nil{
                navigationItem.rightBarButtonItem = navigationItem.leftBarButtonItem
                navigationItem.leftBarButtonItem = nil
                navigationItem.setHidesBackButton(true, animated: false)
            }
        }
    }
}
