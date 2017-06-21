//
//  ActivityIndicator.swift
//  GuildWars2
//
//  Created by Lord Summerisle on 6/11/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import UIKit

class ActivityIndicator: UIActivityIndicatorView {
    
    private struct Constants {
        static let tagNo = 007
        static let yCoordinate: CGFloat = 200.0
        static let width: CGFloat = 80.0
        static let height: CGFloat = 80.0
    }
    
    var activityIndicator = UIActivityIndicatorView()
    let activityIndicatorBackgroundView = UIView()
    
    func setupActivityIndicator(view: UIView) {
        activityIndicatorBackgroundView.tag = Constants.tagNo
        activityIndicatorBackgroundView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height)
        activityIndicatorBackgroundView.backgroundColor = .white
        view.addSubview(activityIndicatorBackgroundView)
        
        activityIndicator.frame = CGRect(x:0 , y: Constants.yCoordinate, width: Constants.width, height: Constants.height)
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorBackgroundView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: activityIndicatorBackgroundView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: activityIndicatorBackgroundView.centerYAnchor).isActive = true
        
    }
    
    func stopActivityIndicator(view: UIView) {
        if view.subviews.contains(activityIndicatorBackgroundView) && activityIndicatorBackgroundView.tag == Constants.tagNo {
            activityIndicator.stopAnimating()
            activityIndicatorBackgroundView.removeFromSuperview()
        }
    }

}
