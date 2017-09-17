//
//  StrayAnimalEntryTableViewCell.swift
//  Badalementini
//
//  Created by Lord Summerisle on 6/21/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import UIKit

protocol PresentImagePickerDelegate {
    func presentImagePicker()
    func textFieldInfo(tf: String, tf2: String, tf3: String)
}

class StrayAnimalEntryTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    private struct Constants {
        static let strayTag = 1
        static let nameTag = 2
        static let numberTag = 3
        static let cornerRadius: CGFloat = 5.0
        static let borderWidth: CGFloat = 1.0
        static let viewHeight: CGFloat = 50.0
        static let viewWidth: CGFloat = 100
        static let originX: CGFloat = 50.0
        static let originY: CGFloat = 150.0
        static let takePhoto = "Take a Photo"
    }
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var strayAnimalimageView: UIImageView!
    @IBOutlet weak var takePhotoButton: UIButton!
    var delegate: PresentImagePickerDelegate?
    @IBOutlet weak var strayAnimalInfoTextField: UITextField!
    @IBOutlet weak var contactPhoneNUmber: UITextField!
    @IBOutlet weak var contactName: UITextField!
    var isPhotoButtonTapped = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupButton()
        setupStrayAnimalimageView()
        setupTextFields()
        selectionStyle = .none
    }
    
    func setupTextFields() {
        contactPhoneNUmber.isHidden = true
        contactName.isHidden = true
        strayAnimalInfoTextField.tag = Constants.strayTag
        contactName.tag = Constants.nameTag
        contactPhoneNUmber.tag = Constants.numberTag
        strayAnimalInfoTextField.delegate = self
        contactPhoneNUmber.delegate = self
        contactName.delegate = self
        contactPhoneNUmber.keyboardType = .numbersAndPunctuation
        strayAnimalInfoTextField.isEnabled = false
        contactPhoneNUmber.isEnabled = false
        contactName.isEnabled = false
    }
    
    func setupStrayAnimalimageView() {
        strayAnimalimageView.layer.cornerRadius = Constants.cornerRadius
        strayAnimalimageView.layer.masksToBounds = true
        strayAnimalimageView.layer.borderColor = UIColor.black.cgColor
        strayAnimalimageView.layer.borderWidth = Constants.borderWidth
        
    }
    func setupButton() {
        takePhotoButton.setTitleColor(.white, for: .normal)
        takePhotoButton.backgroundColor = .purple
        takePhotoButton.setTitle(Constants.takePhoto, for: .normal)
        takePhotoButton.frame.size = CGSize(width: Constants.viewWidth, height: Constants.viewHeight)
        takePhotoButton.frame.origin = CGPoint(x: Constants.originX, y: Constants.originY)
        takePhotoButton.layer.cornerRadius = Constants.cornerRadius
        takePhotoButton.layer.borderWidth = Constants.borderWidth
        takePhotoButton.layer.borderColor = UIColor.white.cgColor
        takePhotoButton.isUserInteractionEnabled = true
    }
    
    @IBAction func takeStrayAnimalPhoto(_ sender: UIButton) {
        self.delegate?.presentImagePicker()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let strayTextField = strayAnimalInfoTextField.text, let contactName = contactName.text, let contactPhone = contactPhoneNUmber.text {
              self.delegate?.textFieldInfo(tf: strayTextField, tf2: contactName, tf3: contactPhone)
        }
        strayAnimalInfoTextField.resignFirstResponder()
        contactName.resignFirstResponder()
        contactPhoneNUmber.resignFirstResponder()
        return true
    }
}
