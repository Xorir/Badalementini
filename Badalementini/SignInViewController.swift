//
//  SignInViewController.swift
//  Badalementini
//
//  Created by Lord Summerisle on 5/15/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    var reference = FIRDatabaseReference.init()
    var currentUser: FIRUser?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        if let user = FIRAuth.auth()?.currentUser {
            print("USER ELAMIL ADDRESS \(FIRAuth.auth()?.currentUser?.email)")
            self.signedIn(user)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        reference = FIRDatabase.database().reference()
        
        //        reference.child("deneme").child((FIRAuth.auth()?.currentUser?.uid)!).setValue("ameno domimre")
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            // Register user to database
            guard let userEmail = user?.email else { return }
            var messageDeneme = [String: String]()
            messageDeneme = ["email": userEmail]
            
            guard let uid = AppState.sharedInstance.UID else { return }
            UserManager.sharedInstance.ref.child("users").child(uid).setValue(messageDeneme)
            
        }
    }
    
    @IBAction func signInTapped(_ sender: UIButton) {
        // Sign In with credentials.
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.signedIn(user!)
        }
        //    signedIn(nil)
        
    }
    
    func signedIn(_ user: FIRUser?) {
        AppState.sharedInstance.displayName = user?.displayName ?? user?.email
        AppState.sharedInstance.signedIn = true
        AppState.sharedInstance.UID = user?.uid
        performSegue(withIdentifier: "SignedIn", sender: nil)
    }
}
