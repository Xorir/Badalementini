//
//  UserLocationManager.swift
//  Badalementini
//
//  Created by Lord Summerisle on 5/25/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import Foundation
import CoreLocation

class UserLocationManager: NSObject {
    
    static let sharedInstance = UserLocationManager()
    var locationValues: CLLocationCoordinate2D?
    var postalCode: String!
    var administrativeArea: String!
    var locality: String!
    var areaOfInterest: String!
    var name: String!
    var thoroughfare: String!
    var address: String!
    
    func formatAddress(name: String, areaOfInterest: String, administrativeArea: String) -> String {
        return name + " " + areaOfInterest + " " + " " + administrativeArea
    }
}
