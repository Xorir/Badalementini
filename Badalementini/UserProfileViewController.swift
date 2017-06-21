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
    
    var checkPostedItemsButton: EntryButtons!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupCheckPostButton()
        title = "User Profile"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOutBarButton(_ sender: UIBarButtonItem) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            AppState.sharedInstance.signedIn = false
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    func setupCheckPostButton() {
        checkPostedItemsButton = EntryButtons(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        checkPostedItemsButton.setTitle("Check My Posts", for: .normal)
        
        view.addSubview(checkPostedItemsButton)
        
        checkPostedItemsButton.translatesAutoresizingMaskIntoConstraints = false
        checkPostedItemsButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -8).isActive = true
        checkPostedItemsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        checkPostedItemsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
