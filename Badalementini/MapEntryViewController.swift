//
//  MapEntryViewController.swift
//  Badalementini
//
//  Created by Lord Summerisle on 5/24/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseStorage

public class EntryButtons: UIButton {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureButton() {
        self.backgroundColor = .purple
        self.setTitle("Upload Image", for: .normal)
        self.frame.size = CGSize(width: 100, height: 50)
        self.frame.origin = CGPoint(x: 50, y: 150)
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.white.cgColor
    }
    
}

class MapEntryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var reference = FIRDatabaseReference.init()
    var enterInfoTextField: UITextField! = nil
    var customNavigationbar: UINavigationBar! = nil
    var animalImageView: UIImageView! = nil
    var uploadImageButton: UIButton!
    var uploadImage: EntryButtons!
    let imagePicker = UIImagePickerController()
    var sendButton: EntryButtons!
    var activityIndicator = UIActivityIndicatorView()
    var activityIndicatorBackgroundView: UIView!
    var isMissingPet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setAnimalImageView()
        setUploadImageButton()
        setTextfield()
        imagePicker.delegate = self
        
    }
    
    @IBAction func sendInfo(_ sender: UIButton) {

        
    }
    
    func done() {
        dismiss(animated: true, completion: nil)
    }
    
    func addMissingPetFunc() {
        print("Missing pet")
    }
    
    func displayIndicator() {
        activityIndicatorBackgroundView = UIView(frame: CGRect(x: 50, y: 100, width: 80, height: 80))
        activityIndicatorBackgroundView.backgroundColor = UIColor.gray
        activityIndicatorBackgroundView.layer.cornerRadius = 5.0
        activityIndicatorBackgroundView.center = view.center
        view.addSubview(activityIndicatorBackgroundView)
            
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.center = activityIndicatorBackgroundView.center
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    
    func hideIndicator() {
        activityIndicator.stopAnimating()
        activityIndicatorBackgroundView.removeFromSuperview()
    }
    
    func sendPhoto() {
        // Upload image to Firebase
        guard let userID = AppState.sharedInstance.UID else { return }
        guard let pickedImage = animalImageView.image else { return }
        var metaDataOut: FIRStorageMetadata?
        
        let storage = FIRStorage.storage().reference().child(userID)
        if let uploadData = UIImagePNGRepresentation(pickedImage) {
            displayIndicator()
            storage.put(uploadData, metadata: nil, completion: { (metaData, error) in
                if error != nil {
                    print(error)
                    return
                }
                
                metaDataOut = metaData
                print("METADATA \(metaData)")
                self.createNewEntry(metaDataImage: metaData)
                // make self weak
                self.hideIndicator()
                
            })
        }
    }
    
    func createNewEntry(metaDataImage: FIRStorageMetadata?) {
        
        // enter info to Firebase DB
        reference = FIRDatabase.database().reference()
        guard let locationValues = UserLocationManager.sharedInstance.locationValues else { return }
        guard let currentUser = FIRAuth.auth()?.currentUser?.uid else { return }
        guard let infoText = enterInfoTextField.text else { return }
        guard let metaData = metaDataImage?.downloadURL()?.absoluteString else { return }
        guard let address = UserLocationManager.sharedInstance.address else { return }
        
        let coordinates: [String: AnyObject] = [
            "lat": locationValues.latitude as AnyObject,
            "long": locationValues.longitude as AnyObject,
            "userName": currentUser as AnyObject,
            "notes": infoText as AnyObject,
            "metaData": metaData as AnyObject,
            "date": getCurrentDate() as AnyObject,
            "address": address as AnyObject
        ]
        
        guard let currentCity = UserLocationManager.sharedInstance.locality else { return }
        
        if isMissingPet {
            reference.child(currentCity).child("missingPet").childByAutoId().setValue(coordinates)
            reference.child("userPosts").child(currentUser).childByAutoId().setValue(coordinates)
        } else {
            reference.child(currentCity).childByAutoId().setValue(coordinates)
        }
        enterInfoTextField.text = ""
    }
    
    func getCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let formattedDate = formatter.string(from: date)
        return formattedDate
    }
    
    func getPhotos() {
        print("test deneme")
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            animalImageView.contentMode = .scaleAspectFit
            animalImageView.image = pickedImage
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
