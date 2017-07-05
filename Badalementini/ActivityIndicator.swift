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
        static let imageViewTagNo = 008
        static let yCoordinate: CGFloat = 200.0
        static let width: CGFloat = 80.0
        static let height: CGFloat = 80.0
        static let viewHeightAndWidth: CGFloat = 100.0
    }
    
    var activityIndicator = UIActivityIndicatorView()
    var activityIndicatorBackgroundView = UIView()
    
    func setupActivityIndicator(view: UIView, isFullScreen: Bool) {
        activityIndicatorBackgroundView.tag = Constants.tagNo
        
        if isFullScreen {
            activityIndicatorBackgroundView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
            activityIndicatorBackgroundView.backgroundColor = .white
        } else {
            activityIndicatorBackgroundView.frame = CGRect(x: 0, y: 0, width: Constants.viewHeightAndWidth, height: Constants.viewHeightAndWidth)
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
    
    
    func setupActivityIndicatorForImageView(imageView: UIImageView, isFullScreen: Bool) {
        activityIndicatorBackgroundView.tag = Constants.tagNo
        
        if isFullScreen {
            activityIndicatorBackgroundView.frame = CGRect(x: 0, y: 0, width: imageView.bounds.size.width, height: imageView.bounds.size.height)
            activityIndicatorBackgroundView.backgroundColor = .white
        } else {
            activityIndicatorBackgroundView.frame = CGRect(x: 0, y: 0, width: Constants.viewHeightAndWidth, height: Constants.viewHeightAndWidth)
            activityIndicatorBackgroundView.backgroundColor = .black
        }
        
        imageView.addSubview(activityIndicatorBackgroundView)
        activityIndicatorBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorBackgroundView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        activityIndicatorBackgroundView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        activityIndicator.frame = CGRect(x:0 , y: Constants.yCoordinate, width: Constants.width, height: Constants.height)
        
        if isFullScreen {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        } else {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        }
        
        activityIndicatorBackgroundView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: activityIndicatorBackgroundView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: activityIndicatorBackgroundView.centerYAnchor).isActive = true
        
    }

    func stopActivityIndicator(imageView: UIImageView) {
        if imageView.subviews.contains(activityIndicatorBackgroundView) && activityIndicatorBackgroundView.tag == Constants.tagNo {
            activityIndicator.stopAnimating()
            activityIndicatorBackgroundView.removeFromSuperview()
        }
    }
}
