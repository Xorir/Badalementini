//
//  UserPostsViewController.swift
//  Badalementini
//
//  Created by Lord Summerisle on 6/27/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import UIKit
import Firebase

class UserPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var reference = FIRDatabaseReference.init()
    var stray: StrayModel!
    var userMissingPetPosts: [StrayModel]?
    var userStrayAnimalPosts: [StrayModel]?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupTableView()
        title = "user posts"
        getUserMissingPetPosts()
        getUserStrayAnimalPosts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserMissingPetPosts() {
        guard let currentUser = FIRAuth.auth()?.currentUser?.uid else { return }
        
        // make it weak and check naming
        
        reference = FIRDatabase.database().reference()
        reference.child("userPosts").child("missingPet").child("\(currentUser)").observe(.value, with: { (snapshot) -> Void in
            guard let straySnapshot = snapshot.value as? [String: AnyObject] else { return }
            
            var keko = [NSDictionary]()
            keko.append(straySnapshot as NSDictionary)
            var strayArray = [StrayModel]()
            
            for (_, value) in straySnapshot {
                let strayAnimal = StrayModel(dictionary: value as! NSDictionary)
                guard let strayAni = strayAnimal else { return }
                strayArray.append(strayAni)
            }
            
            self.userMissingPetPosts = strayArray
            self.tableView.reloadData()
            
            print("POSTS ARRAY \(strayArray)")
        })
    }
    
    func getUserStrayAnimalPosts() {
        guard let currentUser = FIRAuth.auth()?.currentUser?.uid else { return }
        
        // make it weak and check naming
        
        reference = FIRDatabase.database().reference()
        reference.child("userPosts").child("strayAnimal").child("\(currentUser)").observe(.value, with: { (snapshot) -> Void in
            guard let straySnapshot = snapshot.value as? [String: AnyObject] else { return }
            
            var keko = [NSDictionary]()
            keko.append(straySnapshot as NSDictionary)
            var strayArray = [StrayModel]()
            
            for (_, value) in straySnapshot {
                let strayAnimal = StrayModel(dictionary: value as! NSDictionary)
                guard let strayAni = strayAnimal else { return }
                strayArray.append(strayAni)
            }
            
            self.userStrayAnimalPosts = strayArray
            self.tableView.reloadData()
            
            print("POSTS ARRAY \(strayArray)")
        })
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.register(UINib(nibName: "UserPostTableViewCell", bundle: nil), forCellReuseIdentifier: "userPostsIdentifier")
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.tableFooterView = UIView()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if let postCount = userMissingPetPosts?.count {
                return postCount
            }
        } else {
            if let postCount = userStrayAnimalPosts?.count {
                return postCount
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier:
                "userPostsIdentifier", for: indexPath) as! UserPostTableViewCell
            if let userPosts = userMissingPetPosts {
                cell.userPostImageView.getCachedImage(urlString: userPosts[indexPath.row].metaData!)
                cell.addressLabel.text = userPosts[indexPath.row].address
                cell.dateLabel.text = userPosts[indexPath.row].date
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier:
                "userPostsIdentifier", for: indexPath) as! UserPostTableViewCell
            if let userPosts = userStrayAnimalPosts {
                cell.userPostImageView.getCachedImage(urlString: userPosts[indexPath.row].metaData!)
                cell.addressLabel.text = userPosts[indexPath.row].address
                cell.dateLabel.text = userPosts[indexPath.row].date
            }
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            if indexPath.section == 0 {
                
                if let deletionLink = userMissingPetPosts?[indexPath.row].deletionLink {
                    reference = FIRDatabase.database().reference()
                    reference.child(formatDeletionLink(link: deletionLink)).removeValue(completionBlock: { (error, refer) in
                        let keki = self.reference.child(self.formatDeletionLink(link: deletionLink))
                        print("darn keki \(keki)")
                        if error == nil {
                            print("post deleted")
                        }
                    })
                }
                
                
                if let userPostDeletionLink = userMissingPetPosts?[indexPath.row].userPostDeletionLink {
                    reference = FIRDatabase.database().reference()
                    reference.child(formatDeletionLink(link: userPostDeletionLink)).removeValue(completionBlock: { (error, refer) in
                        let keki = self.reference.child(self.formatDeletionLink(link: userPostDeletionLink))
                        print("darn keki \(keki)")
                        if error == nil {
                            print("user post deleted")
                        }
                    })
                }
                
                userMissingPetPosts?.remove(at: indexPath.row)

                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            } else {
                
                if let deletionLink = userStrayAnimalPosts?[indexPath.row].deletionLink {
                    reference = FIRDatabase.database().reference()
                    reference.child(formatDeletionLink(link: deletionLink)).removeValue(completionBlock: { (error, refer) in
                        let keki = self.reference.child(self.formatDeletionLink(link: deletionLink))
                        print("darn keki \(keki)")
                        if error == nil {
                            print("post deleted")
                        }
                    })
                }
                
                if let userPostDeletionLink = userStrayAnimalPosts?[indexPath.row].userPostDeletionLink {
                    reference = FIRDatabase.database().reference()
                    reference.child(formatDeletionLink(link: userPostDeletionLink)).removeValue(completionBlock: { (error, refer) in
                        let keki = self.reference.child(self.formatDeletionLink(link: userPostDeletionLink))
                        print("darn keki \(keki)")
                        if error == nil {
                            print("user post deleted")
                        }
                    })
                }
                
                userStrayAnimalPosts?.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                
            }
        }
    }
    
    func formatDeletionLink(link: String) -> String {
        let formattedDeletionLink = link.replacingOccurrences(of: "https://badalementini.firebaseio.com/", with: "")
        
        return formattedDeletionLink
    }
}
