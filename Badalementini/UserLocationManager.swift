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
    
    public func reverseGeocoding(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { [weak self] (placemarks, error) -> Void in
            guard let strongSelf = self else { return }
            
            if error != nil {
                print(error)
                return
            } else {
                if let placeMark = placemarks?.first {
                    strongSelf.postalCode = placeMark.postalCode
                    strongSelf.administrativeArea = placeMark.administrativeArea
                    strongSelf.locality = placeMark.locality
                }
            }
        })
    }
}
