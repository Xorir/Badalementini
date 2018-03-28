//
//  UserProfileViewController.swift
//  Badalementini
//
//  Created by Lord Summerisle on 6/7/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import UIKit
import Firebase

class UserProfileViewController: UIViewController {
    
    private struct Constants {
        static let userProfileTitle = "User Profile"
        static let keyPressed = "keyPressed"
        static let checkAndDelete = "Check and Delete My Posts"
        static let mainStoryboard = "Main"
        static let userPostIdentifier = "userPostsVC"
        static let buttonWidth: Double = 50.0
        static let buttonHeight: Double = 20.0
    }
    
    var checkPostedItemsButton: EntryButtons!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupCheckPostButton()
        title = Constants.userProfileTitle
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOutBarButton(_ sender: UIBarButtonItem) {
        if AppState.sharedInstance.isFaceBookUser {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.keyPressed), object: nil)
        }
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            AppState.sharedInstance.signedIn = false
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    func getPosts() {
        let mainStoryBoard = UIStoryboard(name: Constants.mainStoryboard, bundle: nil)
        let userPostsVC = mainStoryBoard.instantiateViewController(withIdentifier: Constants.userPostIdentifier) as! UserPostsViewController
        navigationController?.pushViewController(userPostsVC, animated: true)
    }
    
    func setupCheckPostButton() {
        checkPostedItemsButton = EntryButtons(frame: CGRect(x: 0, y: 0, width: Constants.buttonWidth, height: Constants.buttonHeight))
        checkPostedItemsButton.setTitle(Constants.checkAndDelete, for: .normal)
        checkPostedItemsButton.addTarget(self, action: #selector(getPosts), for: .touchUpInside)
        
        view.addSubview(checkPostedItemsButton)
        
        checkPostedItemsButton.translatesAutoresizingMaskIntoConstraints = false
        checkPostedItemsButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -8).isActive = true
        checkPostedItemsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        checkPostedItemsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
    }
}
