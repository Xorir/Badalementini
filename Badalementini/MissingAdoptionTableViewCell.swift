//
//  MissingAdoptionTableViewCell.swift
//  Badalementini
//
//  Created by Lord Summerisle on 6/29/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import UIKit

class MissingAdoptionTableViewCell: UITableViewCell {

    @IBOutlet weak var missingAdoptionImageView: UIImageView!
    @IBOutlet weak var contactNoLabel: UILabel!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
