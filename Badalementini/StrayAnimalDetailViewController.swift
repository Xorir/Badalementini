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
    
    var annotationInfo: Annotation!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        strayAnimalImageView.layer.cornerRadius = 10.0
        //        strayAnimalImageView.layer.masksToBounds = true
        
        guard let metaData = annotationInfo.metaData else { return }
        //        strayAnimalImageView.image = UIImage(named: "profile")
        //        strayAnimalImageView.setNeedsDisplay()
        //        strayAnimalImageView.getCachedImageWithIndicator(urlString: metaData, imageView: strayAnimalImageView)
        //        infoLabel.text = annotationInfo.info
        //        addressLabel.text = annotationInfo.address
        //        setupImageViewGesture()
        setupTableView()
    }
    
    func setupImageViewGesture() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(displayImageDetail))
        //        strayAnimalImageView.isUserInteractionEnabled = true
        //        strayAnimalImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.layer.cornerRadius = 5.0
        tableView.layer.masksToBounds = true
        tableView.register(UINib(nibName: "StrayAnimalDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "strayAnimalDetail")
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.tableFooterView = UIView()
        
    }
    
    func displayImageDetail() {
        let mapEntryDetailStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let imageDetailVC = mapEntryDetailStoryBoard.instantiateViewController(withIdentifier: "ImageDetailViewController") as! ImageDetailViewController
        imageDetailVC.title = "Image Detail"
        imageDetailVC.annotationInfo = self.annotationInfo
        navigationController?.pushViewController(imageDetailVC, animated: true)
    }
    
    @IBAction func navigateToAddress(_ sender: UIButton) {
        let coordinate = CLLocationCoordinate2DMake(annotationInfo.coordinate.latitude,annotationInfo.coordinate.longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = "Target location"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "strayAnimalDetail" , for: indexPath) as! StrayAnimalDetailTableViewCell
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
        mapItem.name = "Target location"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
}
