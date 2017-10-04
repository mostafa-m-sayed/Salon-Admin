//
//  NotificationDetailsVC.swift
//  Salon-Admin
//
//  Created by Mostafa on 10/3/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class NotificationDetailsVC: UIViewController,AcceptOrder,RejectOrder,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var tableServices: UITableView!
    
    @IBOutlet weak var lblClientName: UILabel!
    
    @IBOutlet weak var lblClientNumber: UILabel!
    
    @IBOutlet weak var lblClientAddress: UILabel!
    
    @IBOutlet weak var lblReservationDate: UILabel!
    @IBOutlet weak var lblReservationTime: UILabel!
    
    @IBOutlet weak var imgPP: UIImageView!
    
    @IBOutlet weak var viewServices: UIView!
    
    var viewActivitySmall : SHActivityView?
    var reservationDetails:Reservation!
    let notificationService = NotificationService()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        initNavigationBar()
        tableServices.delegate = self
        tableServices.dataSource = self
        notificationService.AcceptOrderDelegate = self
        notificationService.RejectOrderDelegate = self
        viewDate.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        viewServices.layer.borderColor = UIColor.groupTableViewBackground.cgColor


    }
    @IBAction func btnCall_Click(_ sender: Any) {
        Helper.sharedInstance.makeCall(phoneNumber:reservationDetails.mobile)
    }
    
    @IBAction func btnMessage_Click(_ sender: Any) {
        Helper.sharedInstance.sendMessage(phoneNumber:reservationDetails.mobile)
    }
    func AcceptOrderSuccess(Message: String){
        viewActivitySmall?.dismissAndStopAnimation()
        showLoader()
        alert(message: Message, buttonMessage: NSLocalizedString("OK", comment: ""))
    }
    func AcceptOrderFail(ErrorMessage:String){
        viewActivitySmall?.dismissAndStopAnimation()
        alert(message: ErrorMessage, buttonMessage: NSLocalizedString("OK", comment: ""))

    }
    
    func RejectOrderSuccess(Message: String){
        viewActivitySmall?.dismissAndStopAnimation()
        showLoader()
        alert(message: Message, buttonMessage: NSLocalizedString("OK", comment: ""))
    }
    func RejectOrderFail(ErrorMessage:String){
        viewActivitySmall?.dismissAndStopAnimation()
        alert(message: ErrorMessage, buttonMessage: NSLocalizedString("OK", comment: ""))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return reservationDetails.services.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationServiceCell") as! NotificationServiceCell
        cell.lblName.text = reservationDetails.services[indexPath.row].serviceName
        cell.lblNumber.text = reservationDetails.services[indexPath.row].personNumber
        return cell
    }
    
    func loadData() {
        imgPP.downloadedFrom(link: reservationDetails.client.img)
        lblClientName.text = reservationDetails.name
        lblClientNumber.text = reservationDetails.mobile
        lblClientAddress.text = "\(reservationDetails.city)-\(reservationDetails.district)-\(reservationDetails.street)-\(reservationDetails.home)"
        lblReservationDate.text = reservationDetails.reservationDay
        lblReservationTime.text = reservationDetails.reservationTime
    }
    @IBAction func btnBack_Click(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func btnAccept_Click(_ sender: Any) {
        showLoader()
        notificationService.AcceptOrder(salonId: Helper.sharedInstance.UserDetails.id, orderId: reservationDetails.id)
    }
    @IBAction func btnReject_Click(_ sender: Any) {
        showLoader()
        notificationService.RejectOrder(salonId: Helper.sharedInstance.UserDetails.id, orderId: reservationDetails.id)

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
        self.navigationItem.title = NSLocalizedString("Notification Details", comment: "")
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
