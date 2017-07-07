//
//  ImageDetailViewController.swift
//  Badalementini
//
//  Created by Lord Summerisle on 6/24/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {
    
    private struct Constants {
        static let borderWidth: CGFloat = 3.0
        static let cornerRadius: CGFloat = 5.0
    }
    
    var annotationInfo: Annotation!
    var missingOrAdoptionPet: StrayModel!
    var isStrayAnimalVC = false
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailImageView.layer.borderWidth = Constants.borderWidth
        detailImageView.layer.borderColor = UIColor.purple.cgColor
        
        if isStrayAnimalVC {
            guard let metaData = annotationInfo.metaData else { return }
            //        detailImageView.getCachedImage(urlString: metaData)
            detailImageView.getCachedImageWithIndicator(urlString: metaData, imageView: detailImageView)
        } else {
            guard let metaData = missingOrAdoptionPet.metaData else { return }
            detailImageView.getCachedImageWithIndicator(urlString: metaData, imageView: detailImageView)
        }
     
        detailImageView.layer.cornerRadius = Constants.cornerRadius
        detailImageView.layer.masksToBounds = true
        
        
        // Do any additional setup after loading the view.
    }
}
