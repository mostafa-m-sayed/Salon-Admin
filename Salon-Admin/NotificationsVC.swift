//
//  NotificationsVC.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/23/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class NotificationsVC: UIViewController,UITableViewDelegate,UITableViewDataSource, GetNotifications {

    @IBOutlet weak var tableView: UITableView!
    var notifications = [Reservation]()
    let notificationService = NotificationService()
    var viewActivitySmall : SHActivityView?
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBar()
        tableView.delegate = self
        tableView.dataSource = self
        notificationService.GetNotificationsDelegate = self
        showLoader()
        notificationService.GetNotifications(salonId: Helper.sharedInstance.UserDetails.id)
        tableView.tableFooterView = UIView()
        //tableView.tableFooterView?.backgroundColor = UIColor.blue
    }

    
    func GetNotificationsSuccess(Notifications: [Dictionary<String,AnyObject>]){
        viewActivitySmall?.dismissAndStopAnimation()
        for notification in Notifications {
            notifications.append(Reservation(reservation: notification))
        }
        tableView.reloadData()
    }
    func GetNotificationsFail(ErrorMessage:String){
        viewActivitySmall?.dismissAndStopAnimation()
        alert(message: ErrorMessage, buttonMessage: NSLocalizedString("OK", comment: ""))
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
        cell.lblName.text = notifications[indexPath.row].name
        cell.img.downloadedFrom(link: notifications[indexPath.row].client.img)
        if notifications[indexPath.row].services.count>0 {
            cell.lblServiceFirstDot.isHidden=false
            cell.lblServiceFirst.text = notifications[indexPath.row].services[0].serviceName
        }
        if notifications[indexPath.row].services.count>1 {
            cell.lblServiceSecondDot.isHidden=false
            cell.lblServiceSecond.isHidden=false
            cell.lblServiceSecond.text = notifications[indexPath.row].services[1].serviceName
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "NotificationDetailsVC") as? NotificationDetailsVC
            nextVC?.reservationDetails = notifications[indexPath.row]
            self.navigationController?.pushViewController(nextVC!, animated: true)
    }
    

    func initNavigationBar(){
        self.navigationItem.title = NSLocalizedString("Notifications", comment: "")
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

}
