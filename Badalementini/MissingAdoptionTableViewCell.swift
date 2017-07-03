//
//  MissingAdoptionTableViewCell.swift
//  Badalementini
//
//  Created by Lord Summerisle on 6/29/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import UIKit

protocol MissingAndAdoptionDelegate {
    func displayImageDetail()
}

class MissingAdoptionTableViewCell: UITableViewCell {

    @IBOutlet weak var missingAdoptionImageView: UIImageView!
    @IBOutlet weak var contactNoLabel: UILabel!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    var delegate: MissingAndAdoptionDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupImageViewGesture()
        self.backgroundColor = UIColor.purple
    }
    
    func setupImageViewGesture() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(displaying))
        missingAdoptionImageView.isUserInteractionEnabled = true
        missingAdoptionImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    func displaying() {
        self.delegate?.displayImageDetail()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
