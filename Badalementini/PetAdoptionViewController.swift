//
//  PetAdoptionViewController.swift
//  Badalementini
//
//  Created by Lord Summerisle on 6/30/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import UIKit
import Firebase

class PetAdoptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private struct Constants {
        static let create = "Add"
        static let petAdoptionTitle = "Pet Adoption"
        static let petAdoption = "petAdoption"
        static let missingPetCell = "MissingPetTableViewCell"
        static let petAdoptionIdentifier = "petAdoptionCell"
        static let rowHeight: CGFloat = 100.0
        static let mainStoryboard = "Main"
        static let mapEntryVC = "MapEntryViewController"
        static let petSection = "petAdoption"
        static let missingAndAdoption = "missingAndAdoption"
        static let widthHeight: CGFloat = 50.0
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    var petAdoptionArray: [StrayModel]!
    var reference = DatabaseReference.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addAdoptPet = UIButton()
        addAdoptPet.setTitle(Constants.create, for: .normal)
        addAdoptPet.setTitleColor(UIColor.white, for: .normal)
        addAdoptPet.frame = CGRect(x: 0, y: 0, width: Constants.widthHeight, height: Constants.widthHeight)
        addAdoptPet.addTarget(self, action: #selector(addPet), for: .touchUpInside)
        let missingPetBarButtonItem = UIBarButtonItem(customView: addAdoptPet)
        navigationItem.rightBarButtonItem = missingPetBarButtonItem
        // Do any additional setup after loading the view.
        title = Constants.petAdoptionTitle
        setupTableView()
        
    }
    
    func addPet() {
        addPetAdomption()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        petAdoptionArray = []
        tableView.reloadData()
        getInfFromFirebase()
    }
    
    func getInfFromFirebase() {
        guard let administrativeArea = UserLocationManager.sharedInstance.administrativeArea else { return }
        
        reference = Database.database().reference()
        reference.child(administrativeArea).child(Constants.petAdoption).observe(.value, with: {  [weak self] (snapshot) -> Void in
            guard let straySnapshot = snapshot.value as? [String: AnyObject] else { return }
            guard let strongSelf = self else { return }
            
            var keko = [NSDictionary]()
            keko.append(straySnapshot as NSDictionary)
            var strayArray = [StrayModel]()
            
            for (_, value) in straySnapshot {
                let strayAnimal = StrayModel(dictionary: value as! NSDictionary)
                guard let strayAni = strayAnimal else { return }
                strayArray.append(strayAni)
            }
            
            strongSelf.petAdoptionArray = strayArray
            strongSelf.tableView.reloadData()
        })
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = Constants.rowHeight
        tableView.register(UINib(nibName: Constants.missingPetCell, bundle: nil), forCellReuseIdentifier: Constants.petAdoptionIdentifier)
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.tableFooterView = UIView()
        
    }
    
    func addPetAdomption() {
        let mapEntryDetailStoryBoard = UIStoryboard(name: Constants.mainStoryboard, bundle: nil)
        let mapDetailVC = mapEntryDetailStoryBoard.instantiateViewController(withIdentifier: Constants.mapEntryVC) as! MapEntryViewController
        mapDetailVC.petSection = Constants.petAdoption
        navigationController?.showDetailViewController(mapDetailVC, sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let petAdoptionArray = petAdoptionArray {
            return petAdoptionArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.petAdoptionIdentifier , for: indexPath) as! MissingPetTableViewCell
        cell.missingPetInfo(missingPet: petAdoptionArray[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mainStoryBoard = UIStoryboard(name: Constants.mainStoryboard, bundle: nil)
        let missingAdoptionVC = mainStoryBoard.instantiateViewController(withIdentifier: Constants.missingAndAdoption) as! MissingAndAdoptionViewController
        missingAdoptionVC.missingAdoptionPet = petAdoptionArray[indexPath.row]
        navigationController?.pushViewController(missingAdoptionVC, animated: true)
        
    }
    
}
