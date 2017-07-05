//
//  Annotation.swift
//  Badalementini
//
//  Created by Lord Summerisle on 5/15/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class Annotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    var metaData: String?
    var userName: String?
    var address: String?
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String, metaData: String, userName: String, address: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.metaData = metaData
        self.userName = userName
        self.address = address
    }
}
