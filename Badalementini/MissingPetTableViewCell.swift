//
//  MissingPetTableViewCell.swift
//  Badalementini
//
//  Created by Lord Summerisle on 6/6/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import UIKit

class MissingPetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var missingPetImageView: UIImageView!
    @IBOutlet weak var missingPetInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //Safe unwarap
        roundImageView()
       
    }
    
    func roundImageView() {
        missingPetImageView.layer.borderWidth = 1.0
        missingPetImageView.layer.masksToBounds = false
        missingPetImageView.layer.borderColor = UIColor.purple.cgColor
        missingPetImageView.layer.cornerRadius = missingPetImageView.frame.size.width / 2
        missingPetImageView.clipsToBounds = true
    }
    
    func missingPetInfo(missingPet: StrayModel) {
        //weak
        missingPetImageView.getCachedImage(urlString: missingPet.metaData!)
        missingPetInfoLabel.text = missingPet.notes
    }

}
