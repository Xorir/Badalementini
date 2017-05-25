//
//  MapEntryViewController.swift
//  Badalementini
//
//  Created by Lord Summerisle on 5/24/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class MapEntryViewController: UIViewController {
    
    @IBOutlet weak var enterInfoTextField: UITextField!
    var postalCode: String?
    var reference = FIRDatabaseReference.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        reverseGeocoding(latitude: 40.634217, longitude: -73.969198)
        
        
//        if let locaValues = UserLocationManager.sharedInstance.locationValues {
//            reverseGeocoding(latitude: locaValues.latitude, longitude: locaValues.latitude)
//        }
    }
    
    @IBAction func sendInfo(_ sender: UIButton) {
        reference = FIRDatabase.database().reference()
        guard let postalCode = postalCode else { return }
        guard let locationValues = UserLocationManager.sharedInstance.locationValues else { return }
        guard let currentUser = FIRAuth.auth()?.currentUser?.uid else { return }
        guard let infoText = enterInfoTextField.text else { return }
        
        
        let coordinates: [String: AnyObject] = [
            "lat": locationValues.latitude as AnyObject,
            "long": locationValues.longitude as AnyObject,
            "userName": currentUser as AnyObject,
            "notes": infoText as AnyObject
        ]
        
        reference.child("PostalCode").child(postalCode).setValue(coordinates)
        enterInfoTextField.text = ""
        
    }
    
    func reverseGeocoding(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { [weak self] (placemarks, error) -> Void in
            guard let strongSelf = self else { return }
            
            if error != nil {
                print(error)
                return
            } else {
                if let placeMark = placemarks?.first {
                    strongSelf.postalCode = placeMark.postalCode
                    print("Locality \(placeMark.administrativeArea)")
                }
            }
        })
    }
}
