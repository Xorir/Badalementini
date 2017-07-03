//
//  MissingPetViewController.swift
//  Badalementini
//
//  Created by Lord Summerisle on 6/5/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class MissingPetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var reference = FIRDatabaseReference.init()
    @IBOutlet weak var tableView: UITableView!
    var missingPetArray: [StrayModel]!
    
    private struct Constants {
        static let missingPetTableViewCellIdentifier = "missingPetTableViewCellIdentifier"
        static let teamMemberCellIdentifier = "teamMemberCell"
        static let estimatedRowHeight: CGFloat = 100.0
        static let team = "team"
        static let json = "json"
        static let meetTheTeam = "Meet The Team"
        static let memberDetail = "MemberDetail"
        static let memberDetailVC = "MemberDetailViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addMissingPet = UIButton()
        addMissingPet.setTitle("Add", for: .normal)
        addMissingPet.setTitleColor(UIColor.red, for: .normal)
        addMissingPet.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        addMissingPet.addTarget(self, action: #selector(addMissingPetFunc), for: .touchUpInside)
        let missingPetBarButtonItem = UIBarButtonItem(customView: addMissingPet)
        navigationItem.rightBarButtonItem = missingPetBarButtonItem
        
        setupTableView()
        title = "Missing Pet"
    }
    
    func getInfFromFirebase() {
        guard let currentCity = UserLocationManager.sharedInstance.locality else { return }
        
        reference = FIRDatabase.database().reference()
        reference.child(currentCity).child("missingPet").observe(.value, with: {  [weak self] (snapshot) -> Void in
            guard let straySnapshot = snapshot.value as? [String: AnyObject] else { return }
            guard let strongSelf = self else { return }
            
            var keko = [NSDictionary]()
            keko.append(straySnapshot as NSDictionary)
            var strayArray = [StrayModel]()
            
            for (_, value) in straySnapshot {
                let strayAnimal = StrayModel(dictionary: value as! NSDictionary)
                guard let strayAni = strayAnimal else { return }
                strayArray.append(strayAni)
                print("STRAY ANIMAL IN MISSING DOG \(strayArray)")
            }
            
            //Make it strongSelf
            strongSelf.missingPetArray = strayArray
            
            //            self.annotationTry(annotationValues: strayArray)
            strongSelf.tableView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getInfFromFirebase()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = Constants.estimatedRowHeight
        tableView.register(UINib(nibName: "MissingPetTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.missingPetTableViewCellIdentifier)
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.tableFooterView = UIView()
        
    }
    
    func displayTheDetail(annotation: Annotation) {
        let strayAnimalDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "StrayAnimalDetail") as! StrayAnimalDetailViewController
        self.navigationController?.pushViewController(strayAnimalDetailVC, animated: true)
    }
    
    func addMissingPetFunc() {
        let mapEntryDetailStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let mapDetailVC = mapEntryDetailStoryBoard.instantiateViewController(withIdentifier: "MapEntryViewController") as! MapEntryViewController
        mapDetailVC.petSection = "missingPet"
        navigationController?.showDetailViewController(mapDetailVC, sender: self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let missingPetArray = missingPetArray {
            return missingPetArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.missingPetTableViewCellIdentifier , for: indexPath) as! MissingPetTableViewCell

        cell.missingPetInfo(missingPet: missingPetArray[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let missingAdoptionVC = mainStoryBoard.instantiateViewController(withIdentifier: "missingAndAdoption") as! MissingAndAdoptionViewController
        missingAdoptionVC.missingAdoptionPet = missingPetArray[indexPath.row]
        navigationController?.pushViewController(missingAdoptionVC, animated: true)
        
    }
    
}
