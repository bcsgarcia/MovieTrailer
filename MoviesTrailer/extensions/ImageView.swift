//
//  ImageView.swift
//  MoviesTrailer
//
//  Created by Bruno Garcia on 05/04/19.
//  Copyright © 2019 Bruno Garcia. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage


let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingUrlString(urlString: String) {
        self.image = UIImage.gif(name: "loading")
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        Alamofire.request("http://image.tmdb.org/t/p/w342\(urlString)").responseImage { response in
            if let image = response.result.value {
                let imageToCache = image
                imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                self.image = imageToCache
            }
        }
    }
    
}
