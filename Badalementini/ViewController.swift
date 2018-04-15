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
import Clarifai
import UserNotifications

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var reference = DatabaseReference.init()
    var stray: StrayModel!
    @IBOutlet weak var postPost: UIButton!
    let activityIndicator = ActivityIndicator()
    var annotationArray = [Annotation]()
    
    private struct Constants {
        static let mapEntryDetail = "MapEntryDetail"
        static let mapEntryIdentifier = "mapEntry"
        static let vcTitle = "Stray Animals"
        static let letLongSpan = 0.01
        static let borderWidth: CGFloat = 2.0
        static let cornerRadius: CGFloat = 5.0
        static let edgeInsets: CGFloat = 10.0
        static let mainStoryBoard = "Main"
        static let mapEntryVC = "MapEntryViewController"
        static let petSection = "strayAnimal"
        static let pinIdentifier = "pin"
        static let pinSegue = "pinSegue"
        static let strayAnimalDetail = "StrayAnimalDetail"
    
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
        
        activityIndicator.setupActivityIndicator(view: self.view, isFullScreen: true)
        
        postPost.layer.borderColor = UIColor.purple.cgColor
        postPost.layer.borderWidth = Constants.borderWidth
        postPost.layer.cornerRadius = Constants.cornerRadius
        postPost.contentEdgeInsets = UIEdgeInsets(top: Constants.edgeInsets, left: Constants.edgeInsets, bottom: Constants.edgeInsets, right: Constants.edgeInsets)
        postPost.backgroundColor = .purple
        postPost.setTitleColor(.white, for: .normal)
        
        mapView.delegate = self
        title = Constants.vcTitle
        FIRMessagingSevice.shared.subscribe(to: "topic")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.removeAnnotations(annotationArray)
        annotationArray = []
        checkStrayAnimals()
        checkPushNotification()
    }
    
    func checkPushNotification(){
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings(){ (setttings) in
                
                switch setttings.authorizationStatus{
                case .authorized:
                    FIRMessagingSevice.shared.subscribe(to: "topic")
                case .denied:
                    FIRMessagingSevice.shared.unSubscribe(from: "topic")

                case .notDetermined:
                    print("something vital went wrong here")
                }
            }
        } else {
            
            let isNotificationEnabled = UIApplication.shared.currentUserNotificationSettings?.types.contains(UIUserNotificationType.alert)
            if let isNotificationEnabled = isNotificationEnabled {
                if isNotificationEnabled {
                    print("enabled notification setting")
                } else{
                    print("setting has been disabled")
                }
            }
         
        }
    }
    
    func centerUserLocation() {
        guard let lat = UserLocationManager.sharedInstance.locationValues?.latitude, let long = UserLocationManager.sharedInstance.locationValues?.longitude else { return }
        let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: Constants.letLongSpan , longitudeDelta: Constants.letLongSpan))
        
        mapView.setRegion(region, animated: false)
    }
    
    func checkStrayAnimals() {
        guard let administrativeArea = UserLocationManager.sharedInstance.administrativeArea else { return }
        
        reference = Database.database().reference()
        reference.child(administrativeArea).child(Constants.petSection).observe(.value, with: { (snapshot) -> Void in
            
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
        let mapEntryDetailStoryBoard = UIStoryboard(name: Constants.mainStoryBoard, bundle: nil)
        let mapDetailVC = mapEntryDetailStoryBoard.instantiateViewController(withIdentifier: Constants.mapEntryVC) as! MapEntryViewController
        mapDetailVC.petSection = Constants.petSection
        locationManager.startUpdatingLocation()
        navigationController?.showDetailViewController(mapDetailVC, sender: self)
    }
    
    func annotationTry(annotationValues: [StrayModel]) {
        
        for anno in annotationValues {
            //Refactor
            if let lat = anno.lat, let long = anno.long, let info = anno.notes, let metaData = anno.metaData, let userName = anno.userName {
                let lokas = CLLocationCoordinate2DMake(lat as CLLocationDegrees, long as CLLocationDegrees)
                
                if let address = anno.address {
                    let value = Annotation(title: userName, coordinate: lokas, info: info, metaData: metaData, userName: userName, address: address)
                    annotationArray.append(value)
                } else {
                    let value = Annotation(title: userName, coordinate: lokas, info: info, metaData: metaData, userName: userName, address: "")
                    annotationArray.append(value)
                }
            }
        }
        
        for city in annotationArray {
            mapView.addAnnotation(city)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is Annotation {
            let identifier = Constants.pinIdentifier
            var annotationView: MKAnnotationView?
            
            _ = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
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
        performSegue(withIdentifier: Constants.pinSegue, sender: self)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let  anno = view as? MKAnnotationView {
            guard let annotation = anno.annotation as? Annotation else { return }
            displayTheDetail(annotation: annotation)
        }
    }
    
    func displayTheDetail(annotation: Annotation) {
        let strayAnimalDetailVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.strayAnimalDetail) as! StrayAnimalDetailViewController
        strayAnimalDetailVC.annotationInfo = annotation
        strayAnimalDetailVC.title = "Stray animal detail"
        
        self.navigationController?.pushViewController(strayAnimalDetailVC, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? StrayAnimalDetailViewController, let annotationView = sender as? MKPinAnnotationView  {
        }
    }
    
    public func reverseGeocoding(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { [weak self] (placemarks, error) -> Void in
            guard let strongSelf = self else { return }
            
            if error != nil {
                strongSelf.activityIndicator.stopActivityIndicator(view: strongSelf.view)
                return
            } else {
                if let placeMark = placemarks?.first {
                    UserLocationManager.sharedInstance.postalCode = placeMark.postalCode
                    UserLocationManager.sharedInstance.administrativeArea = placeMark.administrativeArea
                    UserLocationManager.sharedInstance.locality = placeMark.locality
                    UserLocationManager.sharedInstance.areaOfInterest = placeMark.areasOfInterest?.first
                    UserLocationManager.sharedInstance.name = placeMark.name
                    UserLocationManager.sharedInstance.thoroughfare = placeMark.thoroughfare
                    if let name = placeMark.name, let areaOfInterest = placeMark.areasOfInterest?.first, let administrativeArea = placeMark.administrativeArea {
                        UserLocationManager.sharedInstance.address = UserLocationManager.sharedInstance.formatAddress(name: name, areaOfInterest: areaOfInterest, administrativeArea: administrativeArea)
                    }
                    
                    strongSelf.checkStrayAnimals()
                    strongSelf.centerUserLocation()
                    
                    DispatchQueue.main.async {
                        strongSelf.activityIndicator.stopActivityIndicator(view: strongSelf.view)
                    }
                    
                }
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            let locationValues: CLLocationCoordinate2D = location.coordinate
            locationManager.stopUpdatingLocation()
            UserLocationManager.sharedInstance.locationValues = locationValues
            
            reverseGeocoding(latitude: locationValues.latitude, longitude: locationValues.longitude)
        }
    }
}

