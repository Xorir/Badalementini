//
//  TheActivityIndicator.swift
//  Badalementini
//
//  Created by Lord Summerisle on 6/1/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import UIKit

class TheActivityIndicator: UIActivityIndicatorView {

    let activityIndicator = UIActivityIndicatorView()
    
    func displayIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.startAnimating()
    }
    
    func hideIndicator() {
        activityIndicator.stopAnimating()   
    }

}
