//
//  MissingAndAdoptionViewController.swift
//  Badalementini
//
//  Created by Lord Summerisle on 6/29/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import UIKit

class MissingAndAdoptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MissingAndAdoptionDelegate {
    
    private struct Constants {
        static let missingAndAdoptionCell = "MissingAdoptionTableViewCell"
        static let missingAndAdoptionIndetifier = "missingAdoptionCell"
        static let rowHeight: CGFloat = 100.0
        static let cornerRadius: CGFloat = 5.0
        static let mainStoryboard = "Main"
        static let imageDetailVC = "ImageDetailViewController"
        static let imageDetailTitle = "Image Detail"
    }
    
    @IBOutlet weak var tableView: UITableView!
    var missingAdoptionPet: StrayModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = Constants.rowHeight
        tableView.layer.cornerRadius = Constants.cornerRadius
        tableView.backgroundColor = UIColor.purple
        tableView.register(UINib(nibName: Constants.missingAndAdoptionCell, bundle: nil), forCellReuseIdentifier: Constants.missingAndAdoptionIndetifier)
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.tableFooterView = UIView()
        
    }
    
    func displayImageDetail() {
        let mapEntryDetailStoryBoard = UIStoryboard(name: Constants.mainStoryboard, bundle: nil)
        let imageDetailVC = mapEntryDetailStoryBoard.instantiateViewController(withIdentifier: Constants.imageDetailVC) as! ImageDetailViewController
        imageDetailVC.title = Constants.imageDetailTitle
        imageDetailVC.missingOrAdoptionPet = missingAdoptionPet
        imageDetailVC.isStrayAnimalVC = false
        navigationController?.pushViewController(imageDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.missingAndAdoptionIndetifier , for: indexPath) as! MissingAdoptionTableViewCell
        // unwrap
        cell.missingAdoptionImageView.getCachedImageWithIndicator(urlString: missingAdoptionPet.metaData!, imageView: cell.missingAdoptionImageView)
        cell.infoLabel.text = missingAdoptionPet.notes
        cell.delegate = self
        cell.contactNameLabel.text = missingAdoptionPet.contactName
        cell.contactNoLabel.text = missingAdoptionPet.contactPhoneNumber
        
        return cell
        
    }
}
