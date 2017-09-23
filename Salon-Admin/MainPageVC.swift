//
//  MainPageVC.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/21/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class MainPageVC: UIViewController {
    
    @IBOutlet weak var viewPageContent: UIView!
    
    var profileView : MyProfileVC!
    var ImagesView : ImagesVC!
    var ServicesView : ServicesVC!
    
    var currentActiveViewController: UIViewController?
    
    
    @IBOutlet weak var viewBarServices: UIView!
    @IBOutlet weak var viewBarImages: UIView!
    @IBOutlet weak var viewBarProfile: UIView!
    
    
    @IBOutlet weak var navBtnLogout: UIBarButtonItem!
    @IBOutlet weak var navBtnEdit: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileView = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileVC") as? MyProfileVC
         self.ImagesView = self.storyboard?.instantiateViewController(withIdentifier: "ImagesVC") as? ImagesVC
         self.ServicesView = self.storyboard?.instantiateViewController(withIdentifier: "ServicesVC") as? ServicesVC
        self.activeViewController = self.profileView
        
        initNavigationBar()
    }
    
    
    @IBAction func navBtnLogout_Click(_ sender: Any) {
        Helper.sharedInstance.clearUserData()
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
        self.navigationController?.pushViewController(nextVC!, animated: true)
        
    }
    @IBAction func navBtnEdit_Click(_ sender: Any) {
        if let profileVC = activeViewController as? MyProfileVC{
            if navBtnEdit.title == NSLocalizedString("Edit", comment: ""){
                navBtnEdit.title = NSLocalizedString("Save", comment: "")
                profileVC.enableDisableFields(status: "enable")
            }else{
                navBtnEdit.title = NSLocalizedString("Edit", comment: "")
                profileVC.enableDisableFields(status: "disable")
                profileVC.showLoader()
                
                profileVC.accountService.UpdateProfileUser(id: profileVC.userData.id, name: profileVC.txtName.text!, email: profileVC.txtEmail.text!, password: profileVC.userData.password, mobile: profileVC.txtMobile.text!, countryId: profileVC.txtCountryCode.code, workFrom: profileVC.txtWorkFrom.text!, workTo: profileVC.txtWorkTo.text!, image: profileVC.userData.img, lat: profileVC.userData.lat, lng: profileVC.userData.lng)
            }
            
        }
    }
    
    
    fileprivate var activeViewController: UIViewController? {
        didSet {
            removeInactiveViewController(oldValue)
            updateActiveViewController()
        }
    }
    
    fileprivate func removeInactiveViewController(_ inactiveViewController: UIViewController?) {
        if let profileVC = inactiveViewController as? MyProfileVC{
            if profileVC.txtName.isEnabled{
                profileVC.enableDisableFields(status: "disable")
            }
        }
        if let inActiveVC = inactiveViewController {
            inActiveVC.willMove(toParentViewController: nil)
            
            inActiveVC.view.removeFromSuperview()
            inActiveVC.removeFromParentViewController()
        }
    }
    
    fileprivate func updateActiveViewController() {
        if let activeVC = activeViewController {
            addChildViewController(activeVC)
            
            //activeVC.automaticallyAdjustsScrollViewInsets = true
            activeVC.view.autoresizingMask = UIViewAutoresizing.flexibleHeight
            
            activeVC.view.frame = viewPageContent.bounds
            viewPageContent.addSubview(activeVC.view)
            
            activeVC.didMove(toParentViewController: self)
        }
    }
    
    
    @IBAction func btnSwapViews(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            if currentActiveViewController != profileView {
                activeViewController = profileView
                navBtnEdit.title = NSLocalizedString("Edit", comment: "")
                navBtnEdit.isEnabled = true
                navBtnLogout.title = NSLocalizedString("Logout", comment: "")
                navBtnLogout.isEnabled=true
                viewBarProfile.isHidden=false
                viewBarImages.isHidden=true
                viewBarServices.isHidden=true
            }
            break
        case -1:
            if currentActiveViewController != ImagesView {
                activeViewController = ImagesView
                navBtnEdit.title=""
                navBtnEdit.isEnabled=false
                navBtnLogout.title=""
                navBtnLogout.isEnabled=false
                
                viewBarImages.isHidden=false
                viewBarProfile.isHidden=true
                viewBarServices.isHidden=true
            }
            break
        case -2:
            if currentActiveViewController != ServicesView {
                activeViewController = ServicesView
                navBtnEdit.title=""
                navBtnEdit.isEnabled=false
                navBtnLogout.title=""
                navBtnLogout.isEnabled=false
                
                viewBarServices.isHidden=false
                viewBarProfile.isHidden=true
                viewBarImages.isHidden=true
            }
            break
        default:
            print("unknown")
        }
        
        
    }
    
    
    
    func initNavigationBar(){
        self.navigationItem.title = NSLocalizedString("My Profile", comment: "")
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb:0xF5CFF3)
        self.navigationController?.navigationBar.tintColor =  UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
}
