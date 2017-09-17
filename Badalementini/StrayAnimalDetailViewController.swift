//
//  StrayAnimalDetailViewController.swift
//  Badalementini
//
//  Created by Lord Summerisle on 5/31/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import UIKit
import MapKit

class StrayAnimalDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, StrayAnimalDetailDelegate {
    
    private struct Constants {
        static let strayAnimalCell = "StrayAnimalDetailTableViewCell"
        static let strayAnimalIdentifier = "strayAnimalDetail"
        static let mainStoryboard = "Main"
        static let imageDetailVC = "ImageDetailViewController"
        static let imageDetailTitle = "Image Detail"
        static let targetLocation = "Target Location"
    }
    
    var annotationInfo: Annotation!
    var thePet: StrayModel!
    var isMissingOrAdoptionPet = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupImageViewGesture() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(displayImageDetail))
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.layer.cornerRadius = 5.0
        tableView.layer.borderWidth = 1.0
        tableView.layer.borderColor = UIColor.purple.cgColor
        tableView.backgroundColor = .purple
        tableView.layer.masksToBounds = true
        tableView.register(UINib(nibName: Constants.strayAnimalCell, bundle: nil), forCellReuseIdentifier: Constants.strayAnimalIdentifier)
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.tableFooterView = UIView()
        
    }
    
    func displayImageDetail() {
        let mapEntryDetailStoryBoard = UIStoryboard(name: Constants.mainStoryboard, bundle: nil)
        let imageDetailVC = mapEntryDetailStoryBoard.instantiateViewController(withIdentifier: Constants.imageDetailVC) as! ImageDetailViewController
        imageDetailVC.title = Constants.imageDetailTitle
        imageDetailVC.annotationInfo = self.annotationInfo
        imageDetailVC.isStrayAnimalVC = true
        navigationController?.pushViewController(imageDetailVC, animated: true)
    }
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.strayAnimalIdentifier , for: indexPath) as! StrayAnimalDetailTableViewCell
        cell.delegate = self
        cell.configure(info: self.annotationInfo)
        
        
        return cell
    }
    
    func displayStrayAnimalPhoto() {
        displayImageDetail()
    }
    
    func navigateToTheAddress() {
        let coordinate = CLLocationCoordinate2DMake(annotationInfo.coordinate.latitude,annotationInfo.coordinate.longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = Constants.targetLocation
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
}
