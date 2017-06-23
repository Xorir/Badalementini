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
       
    
    }
    
    func missingPetInfo(missingPet: StrayModel) {
        missingPetImageView.image = UIImage(named: "profile")
        missingPetImageView.getCachedImage(urlString: missingPet.metaData!)
        missingPetInfoLabel.text = missingPet.notes
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        
    }
    
}
