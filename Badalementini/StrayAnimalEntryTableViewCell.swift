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
}

class StrayAnimalEntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var strayAnimalimageView: UIImageView!
    @IBOutlet weak var takePhotoButton: UIButton!
    var delegate: PresentImagePickerDelegate?
    @IBOutlet weak var strayAnimalInfoTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupButton()
        setupStrayAnimalimageView()
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
        print("photo button")
    }
    
}
