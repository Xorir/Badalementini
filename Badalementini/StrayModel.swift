//
//  StrayModel.swift
//  Badalementini
//
//  Created by Lord Summerisle on 5/25/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import Foundation

public struct StrayModel {
    let lat: Double?
    let long: Double?
    let notes: String?
    let userName: String?
    let metaData: String?
    let address: String?
    let deletionLink: String?
    let date: String?
    let userPostDeletionLink: String?
    
    init?(dictionary: NSDictionary) {
        lat = dictionary.value(forKeyPath: "lat") as? Double
        long = dictionary.value(forKeyPath: "long") as? Double
        notes = dictionary.value(forKeyPath: "notes") as? String
        userName = dictionary.value(forKeyPath: "userName") as? String
        metaData = dictionary.value(forKeyPath: "metaData") as? String
        address = dictionary.value(forKeyPath: "address") as? String
        deletionLink = dictionary.value(forKeyPath: "deletionLink") as? String
        date = dictionary.value(forKeyPath: "date") as? String
        userPostDeletionLink = dictionary.value(forKeyPath: "userPostDeletionLink") as? String
     }
}
