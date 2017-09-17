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
import Clarifai

class MapEntryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, PresentImagePickerDelegate, UITextFieldDelegate {
    
    private struct Constants {
        static let strayAnimalEntryTableViewCell = "StrayAnimalEntryTableViewCell"
        static let strayAnimalEntryIdentifier = "strayAnimalEntry"
        static let lat = "lat"
        static let long = "long"
        static let userName = "userName"
        static let notes = "notes"
        static let metaData = "metaData"
        static let date = "date"
        static let address = "address"
        static let contactName = "contactName"
        static let contactPhoneNumber = "contactPhoneNumber"
        static let missingPet = "missingPet"
        static let deletionLink = "deletionLink"
        static let userPosts = "userPosts"
        static let userPostDeletionLink = "userPostDeletionLink"
        static let strayAnimal = "strayAnimal"
        static let petAdoption = "petAdoption"
        static let alert = "Alert"
        static let alertMessage = "Post Created"
        static let ok = "OK!"
        static let dateFormat = "MM/dd/yyyy"
        static let dateAndHour = "MM/dd/yyyy/HH/mm/ss"
        static let retakePhoto = "Re-take Photo"
        static let animalNotFoundMessage = "The image does not contain an animal or the animal is not clearly visible"
        static let photoPlaceHolder = "assembly1"
        static let missingPetInfo = "Enter missing pet info"
        static let uploadAPhoto = "Upload a Photo"
        static let petInfo = "Enter pet info"
        static let animalGoodToGo = "The image is good to use"
        static let takeAPhoto = "Take a Photo"
        
    }
    
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
    var areTextfiledActivated = false
    
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
        tableView.register(UINib(nibName: Constants.strayAnimalEntryTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.strayAnimalEntryIdentifier)
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
        
        let storage = FIRStorage.storage().reference().child(userID).child(getDateAndHour())
        
        if let uploadData = UIImageJPEGRepresentation(pickedImage, 0.8) {
            //            displayIndicator()
            let uploadTask = storage.put(uploadData, metadata: nil, completion: { [weak self] (metaData, error) in
                guard let strongSelf = self else { return }
                
                if error != nil {
                    print(error)
                    return
                }
                
                metaDataOut = metaData
                strongSelf.createNewEntry(metaDataImage: metaData)
                
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
            Constants.lat: locationValues.latitude as AnyObject,
            Constants.long: locationValues.longitude as AnyObject,
            Constants.userName: currentUser as AnyObject,
            Constants.notes: infoText as AnyObject,
            Constants.metaData: metaData as AnyObject,
            Constants.date: getCurrentDate() as AnyObject,
            Constants.address: address as AnyObject
        ]
        
        guard let currentCity = UserLocationManager.sharedInstance.locality else { return }
        guard let administrativeArea = UserLocationManager.sharedInstance.administrativeArea else { return }
        guard let petSection = petSection else { return }
        
        if let section = PetSection(rawValue: petSection) {
            switch section {
                
            case .missingPet :
                if let contactName = self.contactName, let contactPhoneNumber = self.contactPhoneNumber {
                    coordinates.updateValue("\(contactName)" as AnyObject, forKey: Constants.contactName)
                    coordinates.updateValue("\(contactPhoneNumber)" as AnyObject, forKey: Constants.contactPhoneNumber)
                }
                
                let mainPost =  reference.child(administrativeArea).child(Constants.missingPet).childByAutoId()
                mainPost.setValue(coordinates)
                coordinates.updateValue("\(mainPost)" as AnyObject, forKey: Constants.deletionLink)
                
                let userPostDict = reference.child(Constants.userPosts).child(Constants.missingPet).child(currentUser).childByAutoId()
                
                coordinates.updateValue("\(userPostDict)" as AnyObject, forKey: Constants.userPostDeletionLink)
                
                userPostDict.setValue(coordinates)
                
            case .strayAnimal:
                let mainPost = reference.child(administrativeArea).child(Constants.strayAnimal).childByAutoId()
                coordinates.updateValue("\(mainPost)" as AnyObject, forKey: Constants.deletionLink)
                mainPost.setValue(coordinates)
                
                
                let userPostDict = reference.child(Constants.userPosts).child(Constants.strayAnimal).child(currentUser).childByAutoId()
                userPostDict.setValue(coordinates)
                
                coordinates.updateValue("\(userPostDict)" as AnyObject, forKey: Constants.userPostDeletionLink)
                userPostDict.setValue(coordinates)
            case .petAdoption:
                if let contactName = self.contactName, let contactPhoneNumber = self.contactPhoneNumber {
                    coordinates.updateValue("\(contactName)" as AnyObject, forKey: Constants.contactName)
                    coordinates.updateValue("\(contactPhoneNumber)" as AnyObject, forKey: Constants.contactPhoneNumber)
                }
                
                let mainPost =  reference.child(administrativeArea).child(Constants.petAdoption).childByAutoId()
                mainPost.setValue(coordinates)
                coordinates.updateValue("\(mainPost)" as AnyObject, forKey: Constants.deletionLink)
                
                let userPostDict = reference.child(Constants.userPosts).child(Constants.petAdoption).child(currentUser).childByAutoId()
                
                coordinates.updateValue("\(userPostDict)" as AnyObject, forKey: Constants.userPostDeletionLink)
                
                userPostDict.setValue(coordinates)
            }
        }
        
        
        activityIndicator.stopActivityIndicator(view: tableView)
        
        //make it weak
        let alert = UIAlertController(title: Constants.alert, message: Constants.alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: Constants.ok, style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func getCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.dateFormat
        let formattedDate = formatter.string(from: date)
        return formattedDate
    }
    
    // Refactor
    func getDateAndHour() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.dateAndHour
        let formattedDate = formatter.string(from: date)
        return formattedDate.replacingOccurrences(of: "/", with: "")
    }
    
    func getPhotos() {
        imagePicker.allowsEditing = false
        if let petSection = petSection {
            if let section = PetSection(rawValue: petSection){
                switch section {
                case .strayAnimal:
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        imagePicker.sourceType = .camera
                    } else { print("No camera") }
                case .missingPet:
                    imagePicker.sourceType = .photoLibrary
                case .petAdoption:
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        imagePicker.sourceType = .camera
                    } else { print("No camera") }
                }
            }
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.pickedImage = pickedImage
            //make it weak
            ClarifAIInteractor.analyzeImageByBytes(imageByte: pickedImage, handler: { [weak self] (response, error) in
                guard let strongSelf = self else { return }
                
                if error != nil {
                    DispatchQueue.main.async {
                        strongSelf.activityIndicator.stopActivityIndicator(view: strongSelf.tableView)
                    }
                    print("error")
                    return
                } else {
                    var conceptArray = [String]()
                    
                    if let response = response {
                        for concept in response {
                            conceptArray.append(concept.conceptName)
                            print(concept.conceptName)
                            
                        }
                    }
                    
                    let array = ["animal", "pet", "puppy", "cat", "dog", "bird", "dragon"]
                    
                    for animal in array {
                        if conceptArray.contains(animal) {
                            
                            strongSelf.areTextfiledActivated = true
                            DispatchQueue.main.async {
                                strongSelf.activityIndicator.stopActivityIndicator(view: strongSelf.tableView)
                                strongSelf.tableView.reloadData()
                            }
                            strongSelf.present(strongSelf.displayAlertController(title: Constants.alert, message: Constants.animalGoodToGo), animated: true, completion: nil)
                            return
                        } else {
                            strongSelf.present(strongSelf.displayAlertController(title: Constants.alert, message: Constants.animalNotFoundMessage), animated: true, completion: nil)
                            DispatchQueue.main.async {
                                strongSelf.activityIndicator.stopActivityIndicator(view: strongSelf.tableView)
                            }
                            return
                        }
                    }
                    
                }
            })
            
            dismiss(animated: true, completion: {
                self.tableView.reloadData()
                
                DispatchQueue.main.async {
                    self.activityIndicator.setupActivityIndicator(view: self.tableView, isFullScreen: false)
                }
            })
        }
    }
    
    func displayAlertController(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: Constants.ok, style: .default, handler: { (action) in }))
        return alert
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.strayAnimalEntryIdentifier , for: indexPath) as! StrayAnimalEntryTableViewCell
        
        cell.strayAnimalimageView.image = UIImage(named: Constants.photoPlaceHolder)
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
                    cell.strayAnimalInfoTextField.placeholder = Constants.missingPetInfo
                    cell.takePhotoButton.setTitle(Constants.uploadAPhoto, for: .normal)
                case .strayAnimal:
                    print("tray animal")
                case .petAdoption:
                    cell.contactName.isHidden = false
                    cell.contactPhoneNUmber.isHidden = false
                    cell.strayAnimalInfoTextField.placeholder = Constants.petInfo
                    cell.takePhotoButton.setTitle(Constants.takeAPhoto, for: .normal)
                }
            }
        }
        
        if areTextfiledActivated {
            cell.contactName.isEnabled = true
            cell.contactPhoneNUmber.isEnabled = true
            cell.strayAnimalInfoTextField.isEnabled = true
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
    
}
