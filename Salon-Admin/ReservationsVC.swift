//
//  ReservationsVC.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/23/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class ReservationsVC: UIViewController,GetCurrentReservations,GetFinishedReservations,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var viewCurrent: UIView!
    @IBOutlet weak var viewFinished: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewBarFinished: UIView!
    @IBOutlet weak var viewBarCurrent: UIView!
    var viewActivitySmall : SHActivityView?
    var pageType = 0//Current = 0,Finished = 1
    var currentLoaded = false
    var finishedLoaded = false
    var finishedOrders = [Reservation]()
    var currentOrders = [Reservation]()
    let reservationService = ReservationService()
    override func viewDidLoad() {
        super.viewDidLoad()
        addGesture()
        initNavigationBar()
        reservationService.GetCurrentReservationsDelegate = self
        reservationService.GetFinishedReservationsDelegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    override func viewWillAppear(_ animated: Bool) {
        showLoader()
        reservationService.GetCurrentReservations(salonId: Helper.sharedInstance.UserDetails.id)
        reservationService.GetFinishedReservations(salonId: Helper.sharedInstance.UserDetails.id)
    }
    func GetFinishedReservationsSuccess(Reservations: [Dictionary<String,AnyObject>]){
        finishedLoaded = true
        finishedOrders.removeAll()
        if currentLoaded{
            viewActivitySmall?.dismissAndStopAnimation()
        }
        for reservation in Reservations {
            finishedOrders.append(Reservation(reservation: reservation))
        }
    }
    func GetFinishedReservationsFail(ErrorMessage:String){
        finishedLoaded = true
        if currentLoaded{
            viewActivitySmall?.dismissAndStopAnimation()
        }
        print(ErrorMessage)
    }
    func switchTabCurrent(_ sender:UITapGestureRecognizer){
        switchTabs(tabId: 0)
    }
    func switchTabFinished(_ sender:UITapGestureRecognizer){
        switchTabs(tabId: 1)
    }
    func switchTabs(tabId:Int) {
        pageType = tabId
        if tabId==1 {
            viewBarCurrent.isHidden = true
            viewBarFinished.isHidden = false
        }else{
            viewBarCurrent.isHidden = false
            viewBarFinished.isHidden = true
        }
        tableView.reloadData()
    }
    @IBAction func btnSwitchTabs_Click(_ sender: UIButton) {
        if sender.tag==0{
            switchTabs(tabId: 0)
        }else{
            switchTabs(tabId: 1)
        }
    }
    func GetCurrentReservationsSuccess(Reservations: [Dictionary<String,AnyObject>]){
        currentLoaded = true
        currentOrders.removeAll()
        
        if finishedLoaded{
            viewActivitySmall?.dismissAndStopAnimation()
        }
        for reservation in Reservations {
            currentOrders.append(Reservation(reservation: reservation))
        }
        tableView.reloadData()
    }
    func GetCurrentReservationsFail(ErrorMessage:String){
        currentLoaded = true
        if finishedLoaded{
            viewActivitySmall?.dismissAndStopAnimation()
        }
        print(ErrorMessage)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pageType == 1{
            return finishedOrders.count
        }
        return currentOrders.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReservationCell") as! ReservationCell
        if pageType == 1 {
            cell.lblDate.text = finishedOrders[indexPath.row].reservationDay
            cell.lblTime.text = finishedOrders[indexPath.row].reservationTime
            cell.lblName.text = finishedOrders[indexPath.row].name
            cell.img.downloadedFrom(link:finishedOrders[indexPath.row].client.img)
        }else{
            cell.lblDate.text = currentOrders[indexPath.row].reservationDay
            cell.lblTime.text = currentOrders[indexPath.row].reservationTime
            cell.lblName.text = currentOrders[indexPath.row].name
            cell.img.downloadedFrom(link:currentOrders[indexPath.row].client.img)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "ReservationDetailsVC") as? ReservationDetailsVC
        if pageType == 1 {
            nextVC?.reservationDetails = finishedOrders[indexPath.row]
        }else{
            nextVC?.reservationDetails = currentOrders[indexPath.row]
        }
        
        self.navigationController?.pushViewController(nextVC!, animated: true)
    }
    
    func initNavigationBar(){
        self.navigationItem.title = NSLocalizedString("Reservations", comment: "")
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb:0xf5c1f0)
        self.navigationController?.navigationBar.tintColor =  UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.setHidesBackButton(true, animated: false)
    }
    func showLoader(){
        viewActivitySmall = SHActivityView.init()
        viewActivitySmall?.spinnerSize = .kSHSpinnerSizeSmall
        viewActivitySmall?.spinnerColor = UIColor(rgb: 0x522D6A)
        self.view.addSubview(viewActivitySmall!)
        viewActivitySmall?.showAndStartAnimate()
        viewActivitySmall?.center = CGPoint(x: (self.view?.frame.size.width)!/2, y: (self.view?.frame.size.height)!/2)
    }
    func addGesture(){
        let registerClickCurrent = UITapGestureRecognizer(target: self, action: #selector (self.switchTabCurrent(_:)))
        viewCurrent.addGestureRecognizer(registerClickCurrent)
        let registerClickFinished = UITapGestureRecognizer(target: self, action: #selector (self.switchTabFinished(_:)))
        viewFinished.addGestureRecognizer(registerClickFinished)
    }
}
