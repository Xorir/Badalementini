//
//  StrayAnimalDetailViewController.swift
//  Badalementini
//
//  Created by Lord Summerisle on 5/31/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import UIKit
import MapKit

class StrayAnimalDetailViewController: UIViewController {
    
    var annotationInfo: Annotation!
    @IBOutlet weak var strayAnimalImageView: UIImageView!
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        strayAnimalImageView.layer.cornerRadius = 10.0
        strayAnimalImageView.layer.masksToBounds = true
        
        guard let metaData = annotationInfo.metaData else { return }
//        strayAnimalImageView.image = UIImage(named: "profile")
        strayAnimalImageView.setNeedsDisplay()
        strayAnimalImageView.getCachedImageWithIndicator(urlString: metaData, imageView: strayAnimalImageView)
        infoLabel.text = annotationInfo.info
        addressLabel.text = annotationInfo.address
        setupImageViewGesture()
    }
    
    func setupImageViewGesture() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(displayImageDetail))
        strayAnimalImageView.isUserInteractionEnabled = true
        strayAnimalImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    func displayImageDetail() {
        let mapEntryDetailStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let imageDetailVC = mapEntryDetailStoryBoard.instantiateViewController(withIdentifier: "ImageDetailViewController") as! ImageDetailViewController
        imageDetailVC.title = "Image Detail"
        imageDetailVC.annotationInfo = self.annotationInfo
        navigationController?.pushViewController(imageDetailVC, animated: true)
    }
    
    @IBAction func navigateToAddress(_ sender: UIButton) {
        let coordinate = CLLocationCoordinate2DMake(annotationInfo.coordinate.latitude,annotationInfo.coordinate.longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = "Target location"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
}
