//
//  SignInViewController.swift
//  Badalementini
//
//  Created by Lord Summerisle on 5/15/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import UIKit
import Firebase
import FacebookLogin
import FacebookCore

class SignInViewController: UIViewController, LoginButtonDelegate {
    
    var reference = FIRDatabaseReference.init()
    var currentUser: FIRUser?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let loginButton = LoginButton(readPermissions: [ .publicProfile, .email])

    
    override func viewDidAppear(_ animated: Bool) {
        if let user = FIRAuth.auth()?.currentUser {
            self.signedIn(user)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        reference = FIRDatabase.database().reference()
        
        //        reference.child("deneme").child((FIRAuth.auth()?.currentUser?.uid)!).setValue("ameno domimre")
        loginButton.center = view.center
        
        view.addSubview(loginButton)
        loginButton.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keko), name:NSNotification.Name(rawValue: "keyPressed"), object: nil);

    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            // Register user to database
            self.signedIn(user)
            
            
        }
    }
    
    func keko() {
        let loginManager = LoginManager()
        loginManager.logOut()
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
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        print("login \(result)")
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: (AccessToken.current?.authenticationToken)!)
        
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            if let error = error {
                // ...
                return
            }
            // User is signed in
            // ...
            AppState.sharedInstance.isFaceBookUser = true
            self.signedIn(user)
        }
    }
    
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("log outlog")
        
    }
    
    

}

