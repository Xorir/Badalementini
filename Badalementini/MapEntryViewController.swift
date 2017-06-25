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
        super.init(coder: aDecoder)
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

class MapEntryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, PresentImagePickerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    var reference = FIRDatabaseReference.init()
    var enterInfoTextField: UITextField! = nil
    var customNavigationbar: UINavigationBar! = nil
    var animalImageView: UIImageView! = nil
    var uploadImageButton: UIButton!
    var uploadImage: EntryButtons!
    let imagePicker = UIImagePickerController()
    var sendButton: EntryButtons!
    var activityIndicatorBackgroundView: UIView!
    var isMissingPet = false
    var pickedImage: UIImage?
    var infoText: String?
    let activityIndicator = ActivityIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        imagePicker.delegate = self
        setupTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        print("Keyboard height \(keyboardHeight)")
        self.tableViewBottomConstraint.constant = keyboardHeight + 10
    }
    
    func keyboardWillHide(notification:NSNotification) {
        self.tableViewBottomConstraint.constant = 0
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.register(UINib(nibName: "StrayAnimalEntryTableViewCell", bundle: nil), forCellReuseIdentifier: "strayAnimalEntry")
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.tableFooterView = UIView()
        
    }
    
    func done() {
        dismiss(animated: true, completion: nil)
    }
    
    func addMissingPetFunc() {
        print("Missing pet")
    }
    
    func presentImagePicker() {
        getPhotos()
    }
    
    func sendPhoto() {
        
        // Upload image to Firebase
        activityIndicator.setupActivityIndicator(view: self.tableView, isFullScreen: false)
        
        guard let userID = AppState.sharedInstance.UID else { return }
        guard let pickedImage = self.pickedImage else { return }
        var metaDataOut: FIRStorageMetadata?
        
        print("Darn picked image \(pickedImage)")
        
        let storage = FIRStorage.storage().reference().child(userID).child(getDateAndHour())
        
        if let uploadData = UIImageJPEGRepresentation(pickedImage, 0.8) {
            //            displayIndicator()
            let uploadTask = storage.put(uploadData, metadata: nil, completion: { (metaData, error) in
                if error != nil {
                    print(error)
                    return
                }
                
                metaDataOut = metaData
                print("METADATA \(metaData)")
                self.createNewEntry(metaDataImage: metaData)
                // make self weak
                //                self.hideIndicator()
                
            })
            
            //            uploadTask.observe(.progress, handler: { (snapshot) in
            //                guard let progress = snapshot.progress else { return }
            //                self.progress = Float(progress.fractionCompleted)
            //
            //            })
        }
    }
    
    func createNewEntry(metaDataImage: FIRStorageMetadata?) {
        
        // enter info to Firebase DB
        reference = FIRDatabase.database().reference()
        guard let locationValues = UserLocationManager.sharedInstance.locationValues else { return }
        guard let currentUser = FIRAuth.auth()?.currentUser?.uid else { return }
        guard let infoText = self.infoText else { return }
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
        //        enterInfoTextField.text = ""
        
        activityIndicator.stopActivityIndicator(view: tableView)
        
        //make weak
        let alert = UIAlertController(title: "Alert", message: "Post Creaed", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK!", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func getCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let formattedDate = formatter.string(from: date)
        return formattedDate
    }
    
    // Refactor
    func getDateAndHour() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy/HH/mm/ss"
        let formattedDate = formatter.string(from: date)
        return formattedDate.replacingOccurrences(of: "/", with: "")
    }
    
    func getPhotos() {
        print("test deneme")
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.pickedImage = pickedImage
            dismiss(animated: true, completion: {
                self.tableView.reloadData()
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "strayAnimalEntry" , for: indexPath) as! StrayAnimalEntryTableViewCell
        
        cell.strayAnimalimageView.image = UIImage(named: "profile")
        if let pickedImage = self.pickedImage {
            cell.strayAnimalimageView.image = pickedImage
        }
        cell.strayAnimalInfoTextField.delegate = self
        cell.strayAnimalInfoTextField.keyboardType = .numbersAndPunctuation
        cell.strayAnimalInfoTextField.returnKeyType = .done
        cell.delegate = self
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.infoText = textField.text
        sendPhoto()
        textField.resignFirstResponder()
        print(textField.text)
        return true
    }
}
