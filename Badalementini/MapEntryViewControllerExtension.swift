//
//  MapEntryViewControllerExtension.swift
//  Badalementini
//
//  Created by Lord Summerisle on 6/7/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import Foundation
import UIKit

extension MapEntryViewController {
    
    func setNavigationBar() {
        let screenSize: CGRect = UIScreen.main.bounds
        customNavigationbar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 66))
        let navItem = UINavigationItem(title: "")
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: nil, action: #selector(done))
        
        navItem.leftBarButtonItem = doneItem
        customNavigationbar.setItems([navItem], animated: false)
        self.view.addSubview(customNavigationbar)
    }

}
