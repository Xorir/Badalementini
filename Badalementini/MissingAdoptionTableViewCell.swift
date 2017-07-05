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
    var detailInfoLabel: UILabel! = nil
    
    var delegate: MissingAndAdoptionDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupImageViewGesture()
        self.backgroundColor = UIColor.purple
        
        detailInfoLabel = UILabel(frame: CGRect(x: 50, y: 50, width: 100, height: 50))
        detailInfoLabel.text = "Tap to see image larger"
        detailInfoLabel.backgroundColor = UIColor(white: 1, alpha: 0.5)
        detailInfoLabel.textAlignment = .center
        
        
        missingAdoptionImageView.addSubview(detailInfoLabel)
        detailInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        detailInfoLabel.leadingAnchor.constraint(equalTo: missingAdoptionImageView.leadingAnchor).isActive = true
        detailInfoLabel.trailingAnchor.constraint(equalTo: missingAdoptionImageView.trailingAnchor).isActive = true
        detailInfoLabel.bottomAnchor.constraint(equalTo: missingAdoptionImageView.bottomAnchor).isActive = true
        detailInfoLabel.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
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
