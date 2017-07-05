//
//  StrayAnimalDetailTableViewCell.swift
//  Badalementini
//
//  Created by Lord Summerisle on 6/25/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import UIKit

protocol StrayAnimalDetailDelegate {
    func navigateToTheAddress()
    func displayStrayAnimalPhoto()
}

class StrayAnimalDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var strayAnimalDetailImageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var navigationButton: UIButton!
    
    var annotationInfo: Annotation!
    var delegate: StrayAnimalDetailDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupImageViewGesture()
    }
    
    func setupImageViewGesture() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(displayImageDetail))
        strayAnimalDetailImageView.isUserInteractionEnabled = true
        strayAnimalDetailImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    func displayImageDetail() {
        self.delegate?.displayStrayAnimalPhoto()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(info: Annotation) {
        guard let metaData = info.metaData else { return }
        strayAnimalDetailImageView.getCachedImageWithIndicator(urlString: metaData, imageView: strayAnimalDetailImageView)
        infoLabel.text = info.info
        addressLabel.text = info.address
    }
    
    @IBAction func navigateToTheAddress(_ sender: UIButton) {
        self.delegate?.navigateToTheAddress()
    }
}
