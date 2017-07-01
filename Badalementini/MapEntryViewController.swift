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
    
    private enum TextField: Int {
        case strayAnimalTextField = 0
        case contactName
        case contactPhoneNumber
    }
    
    private enum PetSection: String {
        case missingPet = "missingPet"
        case strayAnimal = "strayAnimal"
        case petAdoption = "petAdoption"
    }
    
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
    var contactPhoneNumber: String?
    var contactName: String?
    var petSection: String?
    
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
        
        
        var coordinates: [String: AnyObject] = [
            "lat": locationValues.latitude as AnyObject,
            "long": locationValues.longitude as AnyObject,
            "userName": currentUser as AnyObject,
            "notes": infoText as AnyObject,
            "metaData": metaData as AnyObject,
            "date": getCurrentDate() as AnyObject,
            "address": address as AnyObject
        ]
        
        guard let currentCity = UserLocationManager.sharedInstance.locality else { return }
        guard let petSection = petSection else { return }
        
        if let section = PetSection(rawValue: petSection) {
            switch section {
            case .missingPet :
                if let contactName = self.contactName, let contactPhoneNumber = self.contactPhoneNumber {
                    coordinates.updateValue("\(contactName)" as AnyObject, forKey: "contactName")
                    coordinates.updateValue("\(contactPhoneNumber)" as AnyObject, forKey: "contactPhoneNumber")
                }
                
                let mainPost =  reference.child(currentCity).child("missingPet").childByAutoId()
                mainPost.setValue(coordinates)
                coordinates.updateValue("\(mainPost)" as AnyObject, forKey: "deletionLink")
                
                let userPostDict = reference.child("userPosts").child("missingPet").child(currentUser).childByAutoId()
                
                coordinates.updateValue("\(userPostDict)" as AnyObject, forKey: "userPostDeletionLink")
                
                userPostDict.setValue(coordinates)
            case .strayAnimal:
                let mainPost = reference.child(currentCity).childByAutoId()
                coordinates.updateValue("\(mainPost)" as AnyObject, forKey: "deletionLink")
                mainPost.setValue(coordinates)
                
                
                let userPostDict = reference.child("userPosts").child("strayAnimal").child(currentUser).childByAutoId()
                userPostDict.setValue(coordinates)
                
                coordinates.updateValue("\(userPostDict)" as AnyObject, forKey: "userPostDeletionLink")
                userPostDict.setValue(coordinates)
            case .petAdoption:
                if let contactName = self.contactName, let contactPhoneNumber = self.contactPhoneNumber {
                    coordinates.updateValue("\(contactName)" as AnyObject, forKey: "contactName")
                    coordinates.updateValue("\(contactPhoneNumber)" as AnyObject, forKey: "contactPhoneNumber")
                }
                
                let mainPost =  reference.child(currentCity).child("petAdoption").childByAutoId()
                mainPost.setValue(coordinates)
                coordinates.updateValue("\(mainPost)" as AnyObject, forKey: "deletionLink")
                
                let userPostDict = reference.child("userPosts").child("petAdoption").child(currentUser).childByAutoId()
                
                coordinates.updateValue("\(userPostDict)" as AnyObject, forKey: "userPostDeletionLink")
                
                userPostDict.setValue(coordinates)
            }
        }
        
        
        activityIndicator.stopActivityIndicator(view: tableView)
        
        //make weak
        let alert = UIAlertController(title: "Alert", message: "Post Created", preferredStyle: UIAlertControllerStyle.alert)
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
        if isMissingPet {
            imagePicker.sourceType = .photoLibrary
        } else {
            imagePicker.sourceType = .camera
        }
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
        
        cell.strayAnimalInfoTextField.keyboardType = .default
        cell.strayAnimalInfoTextField.returnKeyType = .done
        
        if let petSection = petSection {
            if let section = PetSection(rawValue: petSection) {
                switch section {
                case .missingPet :
                    cell.contactName.isHidden = false
                    cell.contactPhoneNUmber.isHidden = false
                    cell.strayAnimalInfoTextField.placeholder = "Enter missin pet info"
                    cell.takePhotoButton.setTitle("Upload a Photo", for: .normal)
                case .strayAnimal:
                    print("tray animal")
                case .petAdoption:
                    cell.contactName.isHidden = false
                    cell.contactPhoneNUmber.isHidden = false
                    cell.strayAnimalInfoTextField.placeholder = "Enter missin pet info"
                    cell.takePhotoButton.setTitle("Upload a Photo", for: .normal)
                }
            }
        }
        
        cell.delegate = self
        return cell
    }
    
    func textFieldInfo(tf: String, tf2: String, tf3: String) {
        self.infoText = tf
        self.contactName = tf2
        self.contactPhoneNumber = tf3
        sendPhoto()
        
        print(tf, tf2, tf3)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let textFieldy = TextField(rawValue: textField.tag) {
            switch textFieldy {
            case .strayAnimalTextField:
                self.infoText = textField.text
                print(infoText)
                
            case .contactName:
                self.contactName = textField.text
                print(contactName)
                
            case .contactPhoneNumber:
                self.contactPhoneNumber = textField.text
                print(contactPhoneNumber)
            }
        }
        sendPhoto()
        textField.resignFirstResponder()
        print(textField.text)
        return true
    }
}
