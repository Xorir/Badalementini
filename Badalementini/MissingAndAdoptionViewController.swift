//
//  MissingAndAdoptionViewController.swift
//  Badalementini
//
//  Created by Lord Summerisle on 6/29/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import UIKit

class MissingAndAdoptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MissingAndAdoptionDelegate {

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
        tableView.estimatedRowHeight = 100.0
        tableView.layer.cornerRadius = 5.0
        tableView.backgroundColor = UIColor.purple
        tableView.register(UINib(nibName: "MissingAdoptionTableViewCell", bundle: nil), forCellReuseIdentifier: "missingAdoptionCell")
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.tableFooterView = UIView()
        
    }
    
    func displayImageDetail() {
        let mapEntryDetailStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let imageDetailVC = mapEntryDetailStoryBoard.instantiateViewController(withIdentifier: "ImageDetailViewController") as! ImageDetailViewController
        imageDetailVC.title = "Image Detail"
        imageDetailVC.missingOrAdoptionPet = missingAdoptionPet
        imageDetailVC.isStrayAnimalVC = false
        navigationController?.pushViewController(imageDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "missingAdoptionCell" , for: indexPath) as! MissingAdoptionTableViewCell
        // unwrap
        cell.missingAdoptionImageView.getCachedImageWithIndicator(urlString: missingAdoptionPet.metaData!, imageView: cell.missingAdoptionImageView)
        cell.infoLabel.text = missingAdoptionPet.notes
        cell.delegate = self
        cell.contactNameLabel.text = missingAdoptionPet.contactName
        cell.contactNoLabel.text = missingAdoptionPet.contactPhoneNumber
        
        return cell
    
    }


}
