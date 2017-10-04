//
//  RoundButton.swift
//  Laundry
//
//  Created by Mostafa on 7/31/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

private var roundKey = false

extension UIView {
    
    @IBInspectable var roundDesign: Bool{
        get{
            return roundKey
        }
        set{
            roundKey = newValue
            
            if roundKey{
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 4
                //self.layer.shadowRadius = 0.8
                //self.layer.shadowOpacity = 3
                //self.layer.shadowOffset = CGSize(width: 0, height: 2)
               // self.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0).cgColor
            }
            else{
                self.layer.cornerRadius = 0
                self.layer.shadowRadius = 0
                self.layer.shadowOpacity = 0
                self.layer.shadowColor = nil
            }
        }
    }
}
