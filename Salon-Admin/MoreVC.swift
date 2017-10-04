//
//  MoreVC.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/23/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class MoreVC: UIViewController,GetAppInfo {
    
    @IBOutlet weak var toggleNotifications: UISwitch!
    @IBOutlet weak var viewTerms: UIView!
    @IBOutlet weak var viewAbout: UIView!
    @IBOutlet weak var viewContact: UIView!
    @IBOutlet weak var viewShare: UIView!
    var lookupService = LookupService()
    var viewActivitySmall : SHActivityView?
    
    var appInfo:AppInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBar()
        addGesture()
        lookupService.GetAppInfoDelegate = self
        showLoader()
        lookupService.GetAppInfo()
    }
    
    func GetAppInfoSuccess(Info: Dictionary<String,AnyObject>){
        viewActivitySmall?.dismissAndStopAnimation()
        appInfo = AppInfo(AppInfo: Info)
        
    }
    func GetAppInfoFail(ErrorMessage:String){
        viewActivitySmall?.dismissAndStopAnimation()
        print(ErrorMessage)
        alert(message: ErrorMessage, buttonMessage: NSLocalizedString("OK", comment: ""))
    }
    func initNavigationBar(){
        self.navigationItem.title = NSLocalizedString("More", comment: "")
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb:0xF5CFF3)
        self.navigationController?.navigationBar.tintColor =  UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.setHidesBackButton(true, animated: false)
    }
    func showAboutUsPage(_ sender:UITapGestureRecognizer){
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "InfoVC") as? InfoVC
        nextVC?.pageType = 2
        if let about = appInfo{
            nextVC?.pageContent = about.aboutUs
        }else{
            nextVC?.pageContent = ""
        }
        self.navigationController?.pushViewController(nextVC!, animated: true)
    }
    func showContactUsPage(_ sender:UITapGestureRecognizer){
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "InfoVC") as? InfoVC
        nextVC?.pageType = 1
        if let about = appInfo{
            nextVC?.pageContent = about.contactUs
        }else{
            nextVC?.pageContent = ""
        }
        self.navigationController?.pushViewController(nextVC!, animated: true)
    }
    func showTermsPage(_ sender:UITapGestureRecognizer){
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "InfoVC") as? InfoVC
        nextVC?.pageType = 3
        if let about = appInfo{
            nextVC?.pageContent = about.terms
        }else{
            nextVC?.pageContent = ""
        }
        self.navigationController?.pushViewController(nextVC!, animated: true)
    }
    func shareApp(_ sender:UITapGestureRecognizer){
        let textToShare = "Atiaf Company"
        
        if let myWebsite = URL(string: "http://atiafapps.com") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = viewShare
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    func addGesture(){
        let showTerms = UITapGestureRecognizer(target: self, action: #selector (self.showTermsPage(_:)))
        viewTerms.addGestureRecognizer(showTerms)
        let showAboutus = UITapGestureRecognizer(target: self, action: #selector (self.showAboutUsPage(_:)))
        viewAbout.addGestureRecognizer(showAboutus)
        let showContactus = UITapGestureRecognizer(target: self, action: #selector (self.showContactUsPage(_:)))
        viewContact.addGestureRecognizer(showContactus)
        let showShareView = UITapGestureRecognizer(target: self, action: #selector (self.shareApp(_:)))
        viewShare.addGestureRecognizer(showShareView)

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
