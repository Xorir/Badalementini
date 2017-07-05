//
//  UserPostTableViewCell.swift
//  Badalementini
//
//  Created by Lord Summerisle on 6/27/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import UIKit

class UserPostTableViewCell: UITableViewCell {

    
    @IBOutlet weak var userPostImageView: UIImageView!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
