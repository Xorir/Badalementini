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
    
    init?(dictionary: NSDictionary) {
        lat = dictionary.value(forKeyPath: "lat") as? Double
        long = dictionary.value(forKeyPath: "long") as? Double
        notes = dictionary.value(forKeyPath: "notes") as? String
        userName = dictionary.value(forKeyPath: "userName") as? String
    }
    
}
