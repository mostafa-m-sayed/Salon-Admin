//
//  UIViewScaleBackgroundImage.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/21/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    func addBackground() {
        // screen width and height:
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        let dimensions:CGRect = CGRect(x: 0, y: 0, width: width, height: height)
        let imageViewBackground = UIImageView(frame: dimensions)
        imageViewBackground.image = UIImage(named: "YOUR IMAGE NAME GOES HERE")
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.scaleToFill
        
        self.addSubview(imageViewBackground)
        self.sendSubview(toBack: imageViewBackground)
    }}
