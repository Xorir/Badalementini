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
    
    private struct Constants {
        static let labelXY: CGFloat = 50.0
        static let labelWidth: CGFloat = 100.0
        static let labelHeight: CGFloat = 50.0
        static let labelText = "Tap to see image larger"
        static let white: CGFloat = 1.0
        static let alpha: CGFloat = 0.5
    }

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
        
        detailInfoLabel = UILabel(frame: CGRect(x: Constants.labelXY, y: Constants.labelXY, width: Constants.labelWidth, height: Constants.labelHeight))
        detailInfoLabel.text = Constants.labelText
        detailInfoLabel.backgroundColor = UIColor(white: Constants.white, alpha: Constants.alpha)
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
