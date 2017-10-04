//
//  ServiceListVC.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/26/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class ServiceListVC: UIViewController,UITableViewDelegate,UITableViewDataSource,GetSalonServices,DeleteService {
    
    var viewActivitySmall : SHActivityView?
    
    @IBOutlet weak var viewAdd: UIView!
    var service = ServiceService()
    @IBOutlet weak var tableView: UITableView!
    var services = [Service]()
    var subcategoryId:String!
    var subcategoryName:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        addGesture()
        tableView.delegate = self
        tableView.dataSource = self
        service.GetSalonServicesDelegate = self
        service.DeleteServiceDelegate = self
        initNavigationBar()
        tableView.tableFooterView = UIView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        showLoader()
        service.GetSalonServices(salonId: Helper.sharedInstance.UserDetails.id, subcategoryId: subcategoryId)
    }
    func DeleteServiceSuccess(message: String){
        viewActivitySmall?.dismissAndStopAnimation()
        print(message)
        service.GetSalonServices(salonId: Helper.sharedInstance.UserDetails.id, subcategoryId: subcategoryId)
        
    }
    func DeleteServiceFail(ErrorMessage:String){
        viewActivitySmall?.dismissAndStopAnimation()
        alert(message: ErrorMessage, buttonMessage:NSLocalizedString("OK", comment: ""))
        print(ErrorMessage)
        
    }
    
    @IBAction func btnBack_Click(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func GetSalonServicesSuccess(salonServices: [Dictionary<String,AnyObject>]){
        viewActivitySmall?.dismissAndStopAnimation()
        services = [Service]()
        for service in salonServices {
            let serializedService = Service(serviceData: service)
            services.append(serializedService)
        }
        tableView.reloadData()
    }
    func GetSalonServicesFail(ErrorMessage:String){
        viewActivitySmall?.dismissAndStopAnimation()
        alert(message: ErrorMessage, buttonMessage:NSLocalizedString("OK", comment: ""))
        print(ErrorMessage)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell") as! ServiceCell
        cell.lblServiceName.text = services[indexPath.row].service_name
        cell.lblPrice.text = "\(services[indexPath.row].price) \(services[indexPath.row].currency)"
        cell.btnMore.tag = indexPath.row
        cell.btnMore.addTarget(self, action: #selector(ServiceListVC.showServiceOptions), for: .touchUpInside)
        return cell
    }
    func showServiceOptions(_ sender: subclassedUIButton){
        let alert =  UIAlertController(title:services[sender.tag].service_name
            , message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title:NSLocalizedString("Edit", comment: ""), style: .default, handler: { (action : UIAlertAction) in
            
            let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "AddService") as? AddServiceVC
            nextVC?.service = self.services[sender.tag]
            nextVC?.subcategoryId = self.subcategoryId
            self.navigationController?.pushViewController(nextVC!, animated: true)
        }))
        alert.addAction(UIAlertAction(title:NSLocalizedString("Delete", comment: ""), style: .default, handler: { (action : UIAlertAction) in
            self.showLoader()
            self.service.DeleteService(serviceId: self.services[sender.tag].id)
        }))
        alert.addAction(UIAlertAction(title:NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { (action : UIAlertAction) in
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    func showAddPage(_ sender:UITapGestureRecognizer){
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "AddService") as? AddServiceVC
        nextVC?.subcategoryId = subcategoryId
        
        self.navigationController?.pushViewController(nextVC!, animated: true)
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
        self.navigationItem.title = NSLocalizedString(subcategoryName, comment: "")
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb:0xf5c1f0)
        self.navigationController?.navigationBar.tintColor =  UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        if Helper.sharedInstance.getAppLanguage() == "ar"{
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            if navigationItem.leftBarButtonItem != nil{
                navigationItem.rightBarButtonItem = navigationItem.leftBarButtonItem
                navigationItem.leftBarButtonItem = nil
                navigationItem.setHidesBackButton(true, animated: false)
            }
        }
        
    }
    func addGesture(){
        let registerClick = UITapGestureRecognizer(target: self, action: #selector (self.showAddPage(_:)))
        viewAdd.addGestureRecognizer(registerClick)
        
    }
}
