//
//  UIImageDownloadFromURL.swift
//  Salon-Admin
//
//  Created by Mostafa on 9/22/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import Foundation
import UIKit
extension UIImageView {
    func downloadedFromUrl(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFromUrl(url: url, contentMode: mode)
    }
}
