//
//  CircleImage.swift
//  Laundry
//
//  Created by Mostafa on 8/10/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

private var CircleKey = false

extension UIView {
    
    @IBInspectable var circleDesign: Bool{
        get{
            return CircleKey
        }
        set{
            CircleKey = newValue
            
            if CircleKey{
               // self.layer.masksToBounds = true
                self.clipsToBounds  = true
                self.layer.cornerRadius = self.frame.size.width/2
                //self.layer.borderWidth = 1.0
            }
            else{
                self.layer.cornerRadius = 0
            }
        }
    }

}
