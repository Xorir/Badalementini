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
    
    func setupActivityIndicator(view: UIView, isFullScreen: Bool) {
        activityIndicatorBackgroundView.tag = Constants.tagNo
        if isFullScreen {
            activityIndicatorBackgroundView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height)
            activityIndicatorBackgroundView.backgroundColor = .white
        } else {
            activityIndicatorBackgroundView.frame = CGRect(x: 0, y: 0, width: 100.0, height: 100.0)
            activityIndicatorBackgroundView.backgroundColor = .black
        }

        view.addSubview(activityIndicatorBackgroundView)
        activityIndicatorBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorBackgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorBackgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        activityIndicator.frame = CGRect(x:0 , y: Constants.yCoordinate, width: Constants.width, height: Constants.height)
        
        if isFullScreen {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

        } else {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        }
        
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
