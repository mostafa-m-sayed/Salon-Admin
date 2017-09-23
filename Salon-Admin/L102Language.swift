//
//  L102Language.swift
//  localization2
//
//  Created by Nourhan Hosny on 5/10/17.
//  Copyright © 2017 BrightCreations. All rights reserved.
//

import UIKit



let APPLE_LANGUAGE_KEY = "AppleLanguages"

class L102Language: NSObject {
    
    class func currentAppleLanguage() -> String{
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
        let current = langArray.firstObject as! String
        return current
    }
    
    
    
    class func setAppleLAnguageTo(lang: String) {
        let userdef = UserDefaults.standard
        userdef.set([lang,currentAppleLanguage()], forKey: APPLE_LANGUAGE_KEY)
        userdef.synchronize()
    }
    
    
    
 

}
