//
//  EntryButtons.swift
//  Badalementini
//
//  Created by Lord Summerisle on 7/8/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import Foundation
import UIKit

public class EntryButtons: UIButton {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureButton() {
        self.backgroundColor = .purple
        self.setTitle("Upload Image", for: .normal)
        self.frame.size = CGSize(width: 100, height: 50)
        self.frame.origin = CGPoint(x: 50, y: 150)
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.white.cgColor
    }
}
