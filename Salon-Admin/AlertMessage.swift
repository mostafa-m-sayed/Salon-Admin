//
//  AlertMessage.swift
//  Laundry
//
//  Created by Mostafa on 8/18/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func alert(message: String, title: String = "", buttonMessage:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: buttonMessage, style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
