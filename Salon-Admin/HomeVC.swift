//
//  HomeVC.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/16/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    
    @IBOutlet weak var viewEnglish: UIView!
    @IBOutlet weak var viewArabic: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.semanticContentAttribute = .forceLeftToRight
        let lang = Helper.sharedInstance.getAppLanguage()
        if lang != ""{
            if let usr =  Helper.sharedInstance.UserDetails{
                setAppLang(lng: lang)
                if usr.id != "" {
                    setAppLang(lng: lang)
                    let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "MainTBC") as? MainTBC
                    self.navigationController?.pushViewController(nextVC!, animated: true)
                    
                }else{
                    setAppLang(lng: lang)
                    let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
                    self.navigationController?.pushViewController(nextVC!, animated: true)

                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.semanticContentAttribut
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setAppLang(lng:String) {
        if lng.contains("ar"){
            L102Language.setAppleLAnguageTo(lang: "ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        else{
            L102Language.setAppleLAnguageTo(lang: "en")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        L012Localizer.DoTheMagic()
    }
    //MARK Events
    @IBAction func btnEnglish_Click(_ sender: Any) {
        Helper.sharedInstance.storeAppLanguage(lang: "en")
        setAppLang(lng: "en")
        
        
//        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
//        rootviewcontroller.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
//        let mainwindow = (UIApplication.shared.delegate?.window!)!
//        mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
//        UIView.transition(with: mainwindow, duration: 0.0, options: .transitionFlipFromLeft, animations: { () -> Void in
//        }) { (finished) -> Void in
//        }
//
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        self.navigationController?.pushViewController(nextVC!, animated: true)
        
    }
    @IBAction func btnArabic_Click(_ sender: Any) {
        Helper.sharedInstance.storeAppLanguage(lang: "ar")
        setAppLang(lng: "ar")

        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        self.navigationController?.pushViewController(nextVC!, animated: true)
        
    }
}

