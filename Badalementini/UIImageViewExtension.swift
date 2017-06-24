//
//  UIImageViewExtension.swift
//  CMBTeam
//
//  Created by Lord Summerisle on 5/19/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage


private var cachedImage = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func getCachedImage(urlString: String) {
        
        let url = NSURL(string: urlString)
        let request = URLRequest(url: url! as URL)
        
//        Alamofire.request(request).responseImage { (response) in
//            
//            if let imageData = response.result.value {
//                print("image downloaded: \(imageData)")
//                DispatchQueue.main.async {
//                    
//                    cachedImage.setObject(imageData, forKey: urlString as AnyObject)
//                    self.image = imageData
//                    
//                }
//            }
//            
//        }
        
                URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
        
                    if error != nil {
                        print(error)
                        return
                    }
        
                    guard let imgData = data else { return }
                    DispatchQueue.main.async {
                        if let downloadedImgData = UIImage(data: imgData) {
                            cachedImage.setObject(downloadedImgData, forKey: urlString as AnyObject)
                            self.image = downloadedImgData
        
                        }
                    }
                }).resume()
    }
}
