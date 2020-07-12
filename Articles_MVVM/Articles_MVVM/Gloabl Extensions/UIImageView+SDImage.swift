//
//  UIImageView+SDImage.swift
//  MVVM Archiecture
//
//  Created by Prince Sojitra on 28/06/20.
//  Copyright © 2020 Prince Sojitra. All rights reserved.
//


import UIKit
import SDWebImage

extension UIImageView {
    func setImageSDWebImage(imgURL: String) {
        let url = imgURL.replacingOccurrences(of: " ", with: "%20")
        self.sd_imageIndicator?.startAnimatingIndicator()
        self.sd_setImage(with: URL(string: url), completed: nil)
    }

    
    func setImageWith(urlString: String, placeholder:UIImage?,imageIndicator:SDWebImageActivityIndicator, completion:((UIImage?, Error?) -> Void)?) {
        if let url = URL(string: urlString) {
            self.sd_imageIndicator = imageIndicator
            self.sd_setImage(with: url, placeholderImage: placeholder, options: .retryFailed, context: nil, progress: nil) { (img, error, cacheType, url) in
                if error != nil {
                    if placeholder == nil {
                        self.image =  UIImage(named: "Placeholder")
                    } else {
                        self.image = placeholder
                    }
                }
                if completion != nil {
                    completion!(img, error)
                }
            }
        }else {
            self.image = placeholder ?? UIImage(named:"Placeholder")
        }
    }
    
}
