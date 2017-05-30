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
    @IBOutlet weak var postPost: UIButton!
    
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
        
        centerUserLocation()
        
        postPost.layer.borderColor = UIColor.purple.cgColor
        postPost.layer.borderWidth = 2.0
        postPost.layer.cornerRadius = 5.0
        postPost.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        postPost.backgroundColor = .purple
        postPost.setTitleColor(.white, for: .normal)
    }
    
    func centerUserLocation() {
        guard let lat = UserLocationManager.sharedInstance.locationValues?.latitude, let long = UserLocationManager.sharedInstance.locationValues?.longitude else {
            return
        }
        let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let currentCity = UserLocationManager.sharedInstance.locality else { return }
        
        reference = FIRDatabase.database().reference()
        reference.child(currentCity).observe(.value, with: { (snapshot) -> Void in
            print("Darn snapshot \(snapshot)")
            guard let straySnapshot = snapshot.value as? [String: AnyObject] else { return }
            
            var keko = [NSDictionary]()
            keko.append(straySnapshot as NSDictionary)
            var strayArray = [StrayModel]()

            
            for (_, value) in straySnapshot {
                let strayAnimal = StrayModel(dictionary: value as! NSDictionary)
                guard let strayAni = strayAnimal else { return }
                strayArray.append(strayAni)
            }
            
            self.annotationTry(annotationValues: strayArray)
            
        })
    }
    
    @IBAction func getCurrent(_ sender: UIButton) {
        let mapEntryDetailStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let mapDetailVC = mapEntryDetailStoryBoard.instantiateViewController(withIdentifier: "MapEntryViewController") as! MapEntryViewController
        navigationController?.showDetailViewController(mapDetailVC, sender: self)
    }
    
    func annotationTry(annotationValues: [StrayModel]) {
        var annotationArray = [Annotation]()
        
        for anno in annotationValues {
            if let lat = anno.lat, let long = anno.long, let info = anno.notes {
                var lokas = CLLocationCoordinate2DMake(lat as CLLocationDegrees, long as CLLocationDegrees)
                
                let value = Annotation(title: "uu", coordinate: CLLocationCoordinate2DMake(lat, long), info: info)
                annotationArray.append(value)
            }
        }
        
        for city in annotationArray {
            mapView.addAnnotation(city)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      if let location = manager.location {
            let locationValues: CLLocationCoordinate2D = location.coordinate
        let center = CLLocationCoordinate2D(latitude: locationValues.latitude, longitude: locationValues.longitude)
        UserLocationManager.sharedInstance.locationValues = locationValues
        UserLocationManager.sharedInstance.reverseGeocoding(latitude: locationValues.latitude, longitude: locationValues.longitude)
        _ = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
//        mapView.setRegion(region, animated: false)
        }
    }
}

