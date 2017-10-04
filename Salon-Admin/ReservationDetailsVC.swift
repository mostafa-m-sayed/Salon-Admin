//
//  ReservationDetailsVC.swift
//  Salon-Admin
//
//  Created by Mostafa on 10/2/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class ReservationDetailsVC: UIViewController,UITableViewDelegate,UITableViewDataSource,ChangeOrderStatus,GetReservationDetails {

    @IBOutlet weak var tableServices: UITableView!
    
    @IBOutlet weak var lblClientName: UILabel!

    @IBOutlet weak var lblClientNumber: UILabel!

    @IBOutlet weak var lblClientAddress: UILabel!

    @IBOutlet weak var lblReservationDate: UILabel!

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var viewBottom: UIView!

    @IBOutlet weak var imgPP: UIImageView!
    
    
    var viewActivitySmall : SHActivityView?
    var reservationDetails:Reservation!
    var totalPrice = 0
    let reservationService = ReservationService()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        initNavigationBar()
        viewBottom.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        tableServices.delegate = self
        tableServices.dataSource = self
        reservationService.ChangeOrderStatusDelegate = self
        reservationService.GetReservationDetailsDelegate = self
        tableServices.reloadData()
    }
    @IBAction func btnCall_Click(_ sender: Any) {
        Helper.sharedInstance.makeCall(phoneNumber:reservationDetails.mobile)
    }
    
    @IBAction func btnMessage_Click(_ sender: Any) {
        Helper.sharedInstance.sendMessage(phoneNumber:reservationDetails.mobile)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservationDetails.services.count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == reservationDetails.services.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReservationServiceFooterCell") as! ReservationServiceFooterCell
            cell.lblTotal.text = "\(totalPrice)"
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReservationServiceCell") as! ReservationServiceCell
            cell.lblServiceName.text = reservationDetails.services[indexPath.row].serviceName
            cell.lblNumber.text = reservationDetails.services[indexPath.row].personNumber
            cell.lblPrice.text = reservationDetails.services[indexPath.row].servicePrice
            totalPrice = totalPrice + Int(reservationDetails.services[indexPath.row].servicePrice)!
            return cell
        }
        
    }
    func GetReservationDetailsSuccess(ReservationDetails: Dictionary<String,AnyObject>){
        viewActivitySmall?.dismissAndStopAnimation()
        reservationDetails = Reservation(reservation: ReservationDetails)
        loadData()
    }
    func GetReservationDetailsFail(ErrorMessage:String){
        viewActivitySmall?.dismissAndStopAnimation()
        alert(message: ErrorMessage, buttonMessage: NSLocalizedString("OK", comment: ""))
    }

    func ChangeOrderStatusSuccess(Message: String){
        viewActivitySmall?.dismissAndStopAnimation()
        showLoader()
        reservationService.GetReservationDetails(orderId: reservationDetails.id)
    }
    func ChangeOrderStatusFail(ErrorMessage:String){
        viewActivitySmall?.dismissAndStopAnimation()
        alert(message: ErrorMessage, buttonMessage: NSLocalizedString("OK", comment: ""))
    }
    
    @IBAction func btnBack_Click(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func loadData() {
        imgPP.downloadedFrom(link: reservationDetails.client.img)
        lblClientName.text = reservationDetails.name
        lblClientNumber.text = reservationDetails.mobile
        lblClientAddress.text = "\(reservationDetails.city)-\(reservationDetails.district)-\(reservationDetails.street)-\(reservationDetails.home)"
        lblStatus.text = Helper.sharedInstance.getStatusName(statusId: reservationDetails.status)
        lblReservationDate.text = "\(reservationDetails.reservationDay) \(reservationDetails.reservationTime)"
    }
    func showLoader(){
        viewActivitySmall = SHActivityView.init()
        viewActivitySmall?.spinnerSize = .kSHSpinnerSizeSmall
        viewActivitySmall?.spinnerColor = UIColor(rgb: 0x522D6A)
        self.view.addSubview(viewActivitySmall!)
        viewActivitySmall?.showAndStartAnimate()
        viewActivitySmall?.center = CGPoint(x: (self.view?.frame.size.width)!/2, y: (self.view?.frame.size.height)!/2)
    }
    @IBAction func btnShowStatus_Click(_ sender: Any) {
        let alert =  UIAlertController(title:NSLocalizedString("Change Order Status", comment: "")
            , message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title:Helper.sharedInstance.getStatusName(statusId: "1"), style: .default, handler: { (action : UIAlertAction) in
            self.showLoader()
            self.reservationService.ChangeOrderStatus(salonId: Helper.sharedInstance.UserDetails.id, orderId: self.reservationDetails.id, statusId: "1")
        }))
        alert.addAction(UIAlertAction(title:Helper.sharedInstance.getStatusName(statusId: "2"), style: .default, handler: { (action : UIAlertAction) in
            self.showLoader()
            self.reservationService.ChangeOrderStatus(salonId: Helper.sharedInstance.UserDetails.id, orderId: self.reservationDetails.id, statusId: "2")
        }))
        alert.addAction(UIAlertAction(title:Helper.sharedInstance.getStatusName(statusId: "3"), style: .default, handler: { (action : UIAlertAction) in
            self.showLoader()
            self.reservationService.ChangeOrderStatus(salonId: Helper.sharedInstance.UserDetails.id, orderId: self.reservationDetails.id, statusId: "3")
        }))
        alert.addAction(UIAlertAction(title:NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { (action : UIAlertAction) in
        }))
        self.present(alert, animated: true, completion: nil)

    }
    func initNavigationBar(){
        self.navigationItem.title = NSLocalizedString("Order Details", comment: "")
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb:0xf5c1f0)
        self.navigationController?.navigationBar.tintColor =  UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.setHidesBackButton(true, animated: false)
        if Helper.sharedInstance.getAppLanguage() == "ar"{
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            if navigationItem.leftBarButtonItem != nil{
                navigationItem.rightBarButtonItem = navigationItem.leftBarButtonItem
                navigationItem.leftBarButtonItem = nil
            }
        }
    }
}
