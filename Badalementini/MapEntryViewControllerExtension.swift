//
//  MapEntryViewControllerExtension.swift
//  Badalementini
//
//  Created by Lord Summerisle on 6/7/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import Foundation
import UIKit

extension MapEntryViewController {
    
//    func setUploadImageButton() {
//        uploadImage = EntryButtons(frame: CGRect(x: 20, y: 120, width: 100, height: 50))
//        view.addSubview(uploadImage)
//        uploadImage.translatesAutoresizingMaskIntoConstraints = false
//        uploadImage.topAnchor.constraint(equalTo: animalImageView.bottomAnchor, constant: 8).isActive = true
//        uploadImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive  = true
//        uploadImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
//        uploadImage.addTarget(self, action: #selector(getPhotos), for: .touchUpInside)
//        
//        sendButton = EntryButtons(frame: CGRect(x: 20, y: 120, width: 100, height: 50))
//        view.addSubview(sendButton)
//        sendButton.setTitle("Send", for: .normal)
//        sendButton.translatesAutoresizingMaskIntoConstraints = false
//        sendButton.topAnchor.constraint(equalTo: animalImageView.bottomAnchor, constant: 100).isActive = true
//        sendButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive  = true
//        sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
//        sendButton.addTarget(self, action: #selector(sendPhoto), for: .touchUpInside)
//        
//    }
//    
//    func setAnimalImageView() {
//        animalImageView = UIImageView(frame: CGRect(x: 20, y: 100, width: 200, height: 200))
//        let image = UIImage(named: "profile.png")
//        animalImageView = UIImageView(image: image)
//        animalImageView.layer.masksToBounds = false
//        animalImageView.layer.cornerRadius = 10.0
//        animalImageView.clipsToBounds = true
//        view.addSubview(animalImageView)
//        animalImageView.translatesAutoresizingMaskIntoConstraints = false
//        animalImageView.topAnchor.constraint(equalTo: customNavigationbar.bottomAnchor, constant: 16).isActive = true
//        animalImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
//        animalImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        animalImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        
//    }
//    
//    func setTextfield() {
//        enterInfoTextField = UITextField(frame: CGRect(x: 20, y: 80, width: 10, height: 30))
//        enterInfoTextField.borderStyle = UITextBorderStyle.roundedRect
//        enterInfoTextField.font = UIFont.systemFont(ofSize: 15)
//        enterInfoTextField.keyboardType = UIKeyboardType.default
//        enterInfoTextField.returnKeyType = UIReturnKeyType.done
//        view.addSubview(enterInfoTextField)
//        enterInfoTextField.translatesAutoresizingMaskIntoConstraints = false
//        enterInfoTextField.topAnchor.constraint(equalTo: uploadImage.bottomAnchor, constant: 8).isActive = true
//        enterInfoTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
//        enterInfoTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8.0 ).isActive = true
//        
//    }
    
    func setNavigationBar() {
        let screenSize: CGRect = UIScreen.main.bounds
        customNavigationbar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 66))
        let navItem = UINavigationItem(title: "")
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: nil, action: #selector(done))
        
        navItem.leftBarButtonItem = doneItem
        customNavigationbar.setItems([navItem], animated: false)
        self.view.addSubview(customNavigationbar)
    }

}
