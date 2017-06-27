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
        contactPhoneNUmber.isHidden = true
        contactName.isHidden = true
        strayAnimalInfoTextField.tag = 1
        contactName.tag = 2
        contactPhoneNUmber.tag = 3
        strayAnimalInfoTextField.delegate = self
        contactPhoneNUmber.delegate = self
        contactName.delegate = self
        contactPhoneNUmber.keyboardType = .numbersAndPunctuation
        strayAnimalInfoTextField.isEnabled = false
        contactPhoneNUmber.isEnabled = false
        contactName.isEnabled = false
        selectionStyle = .none
        
    }
    
    func setupStrayAnimalimageView() {
        strayAnimalimageView.layer.cornerRadius = 5.0
        strayAnimalimageView.layer.masksToBounds = true
        strayAnimalimageView.layer.borderColor = UIColor.black.cgColor
        strayAnimalimageView.layer.borderWidth = 1.0
        
    }
    func setupButton() {
        takePhotoButton.setTitleColor(.white, for: .normal)
        takePhotoButton.backgroundColor = .purple
        takePhotoButton.setTitle("Take Photo", for: .normal)
        takePhotoButton.frame.size = CGSize(width: 100, height: 50)
        takePhotoButton.frame.origin = CGPoint(x: 50, y: 150)
        takePhotoButton.layer.cornerRadius = 5.0
        takePhotoButton.layer.borderWidth = 1.0
        takePhotoButton.layer.borderColor = UIColor.white.cgColor
        takePhotoButton.isUserInteractionEnabled = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func takeStrayAnimalPhoto(_ sender: UIButton) {
        self.delegate?.presentImagePicker()
        strayAnimalInfoTextField.isEnabled = true
        contactPhoneNUmber.isEnabled = true
        contactName.isEnabled = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.delegate?.textFieldInfo(tf: strayAnimalInfoTextField.text!, tf2: contactName.text!, tf3: contactPhoneNUmber.text!)
        strayAnimalInfoTextField.resignFirstResponder()
        contactName.resignFirstResponder()
        contactPhoneNUmber.resignFirstResponder()
        return true
    }
    
    
}
