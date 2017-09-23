//
//  HomeVC.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/16/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let lang = Helper.sharedInstance.getAppLanguage()
        if lang != ""{
            setAppLang(lng: lang)
            if let usr =  Helper.sharedInstance.UserDetails{
                if usr.id != "" {
                    setAppLang(lng: lang)
                    let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "MainPageVC") as? MainPageVC
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

