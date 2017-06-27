//
//  ImageDetailViewController.swift
//  Badalementini
//
//  Created by Lord Summerisle on 6/24/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {
    
    var annotationInfo: Annotation!
    
    @IBOutlet weak var detailImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let metaData = annotationInfo.metaData else { return }
        //        detailImageView.getCachedImage(urlString: metaData)
        detailImageView.getCachedImageWithIndicator(urlString: metaData, imageView: detailImageView)
        detailImageView.layer.cornerRadius = 5.0
        detailImageView.layer.masksToBounds = true
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
