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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
