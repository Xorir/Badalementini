//
//  StrayAnnotationView.swift
//  Badalementini
//
//  Created by Lord Summerisle on 5/31/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import UIKit
import MapKit

class StrayAnnotationView: MKAnnotationView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        image = UIImage(named: "profile")
    }
    
}
