//
//  ViewController.swift
//  Badalementini
//
//  Created by Lord Summerisle on 5/14/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var reference = FIRDatabaseReference.init()
    var stray: StrayModel!

    
    private struct Constants {
        static let mapEntryDetail = "MapEntryDetail"
        static let mapEntryIdentifier = "mapEntry"
    }
    
    var locationManager: CLLocationManager!
    var lat: CLLocationDegrees?
    var long: CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reference = FIRDatabase.database().reference()
        reference.child("PostalCode").child("11218").observe(.value, with: { (snapshot) -> Void in
            print("Darn snapshot \(snapshot)")
            guard let straySnapshot = snapshot.value as? [String: AnyObject] else { return }
            
            // Make weak self
            self.stray = StrayModel(dictionary: straySnapshot as NSDictionary)
            print("LAT: \(self.stray.lat), userName: \(self.stray.userName), LAT: \(self.stray.long), LAT: \(self.stray.notes)")
            
        })
        
        annotationTry()
        
    }
    
    @IBAction func getCurrent(_ sender: UIButton) {
        let mapEntryDetailStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let mapDetailVC = mapEntryDetailStoryBoard.instantiateViewController(withIdentifier: "MapEntryViewController") as! MapEntryViewController
        navigationController?.pushViewController(mapDetailVC, animated: true)
    }
    
    func annotationTry() {
//        let london = Annotation(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
//        let oslo = Annotation(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
//        let paris = Annotation(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
//        let rome = Annotation(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
//        let washington = Annotation(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
//        let cities = [london, oslo, paris, rome, washington]
//        
//        for city in cities {
//            mapView.addAnnotation(city)
//        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      if let location = manager.location {
            let locationValues: CLLocationCoordinate2D = location.coordinate
        let center = CLLocationCoordinate2D(latitude: locationValues.latitude, longitude: locationValues.longitude)
        UserLocationManager.sharedInstance.locationValues = locationValues
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
//        mapView.setRegion(region, animated: false)
        }
        
    }
}

