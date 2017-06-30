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
    
    @IBOutlet weak var tableView: UITableView!
    var petAdoptionArray: [StrayModel]!
    var reference = FIRDatabaseReference.init()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addAdoptPet = UIButton()
        addAdoptPet.setTitle("Add", for: .normal)
        addAdoptPet.setTitleColor(UIColor.red, for: .normal)
        addAdoptPet.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        addAdoptPet.addTarget(self, action: #selector(addPet), for: .touchUpInside)
        let missingPetBarButtonItem = UIBarButtonItem(customView: addAdoptPet)
        navigationItem.rightBarButtonItem = missingPetBarButtonItem
        // Do any additional setup after loading the view.
        title = "Pet Adoption"
        setupTableView()
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addPet() {
        addPetAdomption()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getInfFromFirebase()

    }
    
    
    func getInfFromFirebase() {
        guard let currentCity = UserLocationManager.sharedInstance.locality else { return }
        
        reference = FIRDatabase.database().reference()
        reference.child(currentCity).child("petAdoption").observe(.value, with: {  [weak self] (snapshot) -> Void in
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
            strongSelf.petAdoptionArray = strayArray
            
            //            self.annotationTry(annotationValues: strayArray)
            strongSelf.tableView.reloadData()
        })
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.register(UINib(nibName: "MissingPetTableViewCell", bundle: nil), forCellReuseIdentifier: "petAdoptionCell")
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.tableFooterView = UIView()
        
    }
    
    func addPetAdomption() {
        let mapEntryDetailStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let mapDetailVC = mapEntryDetailStoryBoard.instantiateViewController(withIdentifier: "MapEntryViewController") as! MapEntryViewController
        mapDetailVC.petSection = "petAdoption"
        navigationController?.showDetailViewController(mapDetailVC, sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let petAdoptionArray = petAdoptionArray {
            return petAdoptionArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "petAdoptionCell" , for: indexPath) as! MissingPetTableViewCell
        cell.missingPetInfo(missingPet: petAdoptionArray[indexPath.row])
        
        return cell
    }
    
}
