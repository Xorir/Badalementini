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

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

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
        
        mapView.delegate = self
        
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
            //Refactor
            if let lat = anno.lat, let long = anno.long, let info = anno.notes, let metaData = anno.metaData, let userName = anno.userName {
                var lokas = CLLocationCoordinate2DMake(lat as CLLocationDegrees, long as CLLocationDegrees)
                
                let value = Annotation(title: userName, coordinate: lokas, info: info, metaData: metaData, userName: userName)
                annotationArray.append(value)
            }
        }
        
        for city in annotationArray {
            mapView.addAnnotation(city)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is Annotation {
            let identifier = "pin"
            var annotationView: MKAnnotationView?
            
            var dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = false
                annotationView?.rightCalloutAccessoryView = UIButton(type: .infoLight)
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView

        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "pinSegue", sender: self)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let  anno = view as? MKAnnotationView {
            guard let annotation = anno.annotation as? Annotation else { return }
            displayTheDetail(annotation: annotation)
        }
    }
    
    func displayTheDetail(annotation: Annotation) {
        let strayAnimalDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "StrayAnimalDetail") as! StrayAnimalDetailViewController
        strayAnimalDetailVC.annotationInfo = annotation
        strayAnimalDetailVC.title = annotation.userName
        self.navigationController?.pushViewController(strayAnimalDetailVC, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? StrayAnimalDetailViewController, let annotationView = sender as? MKPinAnnotationView  {
            print("ANNOTATION VIEW \(annotationView)")
            destinationVC.title = "Amonog dorime "
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

