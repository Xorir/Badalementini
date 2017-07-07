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
    
    private struct Constants {
        static let userPostsTitle = "User Posts"
        static let missingPet = "missingPet"
        static let userPosts = "userPosts"
        static let strayAnimal = "strayAnimal"
        static let petAdoption = "petAdoption"
        static let userPostCell = "UserPostTableViewCell"
        static let userPostIdentifier = "userPostsIdentifier"
        static let cell = "theCell"
        static let firebaseFormattedLink = "https://badalementini.firebaseio.com/"
        static let headerHeight: CGFloat = 100.0
    }
    
    enum PostSection: Int {
        case missingPet = 0
        case strayAnimal
        case petAdoption
    }
    
    @IBOutlet weak var tableView: UITableView!
    var reference = FIRDatabaseReference.init()
    var stray: StrayModel!
    var userMissingPetPosts: [StrayModel]?
    var userStrayAnimalPosts: [StrayModel]?
    var userPetAdoptionPosts: [StrayModel]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupTableView()
        title = Constants.userPostsTitle
        getUserMissingPetPosts()
        getUserStrayAnimalPosts()
        getUserPetAdoptionPosts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserMissingPetPosts() {
        guard let currentUser = FIRAuth.auth()?.currentUser?.uid else { return }
        
        // make it weak and check naming
        
        reference = FIRDatabase.database().reference()
        reference.child(Constants.userPosts).child(Constants.missingPet).child("\(currentUser)").observe(.value, with: { (snapshot) -> Void in
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
            
        })
    }
    
    func getUserStrayAnimalPosts() {
        guard let currentUser = FIRAuth.auth()?.currentUser?.uid else { return }
        
        // make it weak and check naming
        
        reference = FIRDatabase.database().reference()
        reference.child(Constants.userPosts).child(Constants.strayAnimal).child("\(currentUser)").observe(.value, with: { (snapshot) -> Void in
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
            
        })
    }
    
    func getUserPetAdoptionPosts() {
        guard let currentUser = FIRAuth.auth()?.currentUser?.uid else { return }
        
        // make it weak and check naming
        
        reference = FIRDatabase.database().reference()
        reference.child(Constants.userPosts).child(Constants.petAdoption).child("\(currentUser)").observe(.value, with: { (snapshot) -> Void in
            guard let straySnapshot = snapshot.value as? [String: AnyObject] else { return }
            
            var keko = [NSDictionary]()
            keko.append(straySnapshot as NSDictionary)
            var strayArray = [StrayModel]()
            
            for (_, value) in straySnapshot {
                let strayAnimal = StrayModel(dictionary: value as! NSDictionary)
                guard let strayAni = strayAnimal else { return }
                strayArray.append(strayAni)
            }
            
            self.userPetAdoptionPosts = strayArray
            self.tableView.reloadData()
            
        })
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.register(UINib(nibName: Constants.userPostCell, bundle: nil), forCellReuseIdentifier: Constants.userPostIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cell)
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.tableFooterView = UIView()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let section = PostSection(rawValue: section) {
            switch section {
            case .missingPet:
                if let postCount = userMissingPetPosts?.count {
                    return postCount
                }
            case .strayAnimal:
                if let postCount = userStrayAnimalPosts?.count {
                    return postCount
                }
            case .petAdoption:
                if let postCount = userPetAdoptionPosts?.count {
                    return postCount
                }
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let section = PostSection(rawValue: indexPath.section) {
            switch section {
            case .missingPet:
                let cell = tableView.dequeueReusableCell(withIdentifier:
                    Constants.userPostIdentifier, for: indexPath) as! UserPostTableViewCell
                if let userPosts = userMissingPetPosts {
                    
                    cell.userPostImageView.getCachedImage(urlString: userPosts[indexPath.row].metaData!)
                    cell.addressLabel.text = userPosts[indexPath.row].address
                    cell.dateLabel.text = userPosts[indexPath.row].date
                    
                }
                return cell
            case .strayAnimal:
                let cell = tableView.dequeueReusableCell(withIdentifier:
                    Constants.userPostIdentifier, for: indexPath) as! UserPostTableViewCell
                if let userPosts = userStrayAnimalPosts {
                    
                    cell.userPostImageView.getCachedImage(urlString: userPosts[indexPath.row].metaData!)
                    cell.addressLabel.text = userPosts[indexPath.row].address
                    cell.dateLabel.text = userPosts[indexPath.row].date
                }
                return cell
            case .petAdoption:
                let cell = tableView.dequeueReusableCell(withIdentifier:
                    Constants.userPostIdentifier, for: indexPath) as! UserPostTableViewCell
                if let userPosts = userPetAdoptionPosts {
                    
                    cell.userPostImageView.getCachedImage(urlString: userPosts[indexPath.row].metaData!)
                    cell.addressLabel.text = userPosts[indexPath.row].address
                    cell.dateLabel.text = userPosts[indexPath.row].date
                }
                return cell
            }
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            
            if let section = PostSection(rawValue: indexPath.section) {
                switch section {
                case .missingPet:
                    
                    if let deletionLink = userMissingPetPosts?[indexPath.row].deletionLink {
                        reference = FIRDatabase.database().reference()
                        reference.child(formatDeletionLink(link: deletionLink)).removeValue(completionBlock: { (error, refer) in
                            let keki = self.reference.child(self.formatDeletionLink(link: deletionLink))
                            if error == nil {
                                print("post deleted")
                            }
                        })
                    }
                    
                    if let userPostDeletionLink = userMissingPetPosts?[indexPath.row].userPostDeletionLink {
                        reference = FIRDatabase.database().reference()
                        reference.child(formatDeletionLink(link: userPostDeletionLink)).removeValue(completionBlock: { (error, refer) in
                            let keki = self.reference.child(self.formatDeletionLink(link: userPostDeletionLink))
                            if error == nil {
                                print("user post deleted")
                            }
                        })
                    }
                    
                    userMissingPetPosts?.remove(at: indexPath.row)
                    
                    tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                    
                case .strayAnimal:
                    
                    if let deletionLink = userStrayAnimalPosts?[indexPath.row].deletionLink {
                        reference = FIRDatabase.database().reference()
                        reference.child(formatDeletionLink(link: deletionLink)).removeValue(completionBlock: { (error, refer) in
                            let keki = self.reference.child(self.formatDeletionLink(link: deletionLink))
                            if error == nil {
                                print("post deleted")
                            }
                        })
                    }
                    
                    if let userPostDeletionLink = userStrayAnimalPosts?[indexPath.row].userPostDeletionLink {
                        reference = FIRDatabase.database().reference()
                        reference.child(formatDeletionLink(link: userPostDeletionLink)).removeValue(completionBlock: { (error, refer) in
                            let keki = self.reference.child(self.formatDeletionLink(link: userPostDeletionLink))
                            if error == nil {
                                print("user post deleted")
                            }
                        })
                    }
                    
                    userStrayAnimalPosts?.remove(at: indexPath.row)
                    
                    tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                case .petAdoption:
                    
                    if let deletionLink = userPetAdoptionPosts?[indexPath.row].deletionLink {
                        reference = FIRDatabase.database().reference()
                        reference.child(formatDeletionLink(link: deletionLink)).removeValue(completionBlock: { (error, refer) in
                            let keki = self.reference.child(self.formatDeletionLink(link: deletionLink))
                            if error == nil {
                                print("post deleted")
                            }
                        })
                    }
                    
                    if let userPostDeletionLink = userPetAdoptionPosts?[indexPath.row].userPostDeletionLink {
                        reference = FIRDatabase.database().reference()
                        reference.child(formatDeletionLink(link: userPostDeletionLink)).removeValue(completionBlock: { (error, refer) in
                            let keki = self.reference.child(self.formatDeletionLink(link: userPostDeletionLink))
                            if error == nil {
                                print("user post deleted")
                            }
                        })
                    }
                    
                    userPetAdoptionPosts?.remove(at: indexPath.row)
                    
                    tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 100.0))
        headerView.backgroundColor = .red
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        headerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
        if let section = PostSection(rawValue: section) {
            switch section {
            case .missingPet:
                if userMissingPetPosts?.count == nil {
                    label.text = "No missing pet posts"
                } else {
                    label.text = "Missing Pet posts"
                }
            case .strayAnimal:
                if userStrayAnimalPosts?.count == nil {
                    label.text = "No stray animal posts"
                } else {
                    label.text = "Stray Animal Posts"
                }
            case .petAdoption:
                    if userPetAdoptionPosts?.count == nil {
                        label.text = "No pet adoption posts"
                    } else {
                        label.text = "Pet Adoption Posts"
                    }
            }
            
        }
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.headerHeight
    }
    
    
    func formatDeletionLink(link: String) -> String {
        let formattedDeletionLink = link.replacingOccurrences(of: Constants.firebaseFormattedLink, with: "")
        
        return formattedDeletionLink
    }
}
