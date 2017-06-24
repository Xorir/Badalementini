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
        
        strayAnimalImageView.layer.cornerRadius = 15.0
        
        guard let metaData = annotationInfo.metaData else { return }
        strayAnimalImageView.image = UIImage(named: "profile")
        strayAnimalImageView.setNeedsDisplay()
        strayAnimalImageView.getCachedImage(urlString: metaData)
        infoLabel.text = annotationInfo.info
        addressLabel.text = annotationInfo.address
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func navigateToAddress(_ sender: UIButton) {
        let coordinate = CLLocationCoordinate2DMake(annotationInfo.coordinate.latitude,annotationInfo.coordinate.longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = "Target location"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
}
