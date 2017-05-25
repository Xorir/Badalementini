//
//  StrayModel.swift
//  Badalementini
//
//  Created by Lord Summerisle on 5/25/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import Foundation

public struct StrayModel {
    let lat: Float?
    let long: Float?
    let notes: String?
    let userName: String?
    
    init?(dictionary: NSDictionary) {
        lat = dictionary.value(forKeyPath: "lat") as? Float
        long = dictionary.value(forKeyPath: "long") as? Float
        notes = dictionary.value(forKeyPath: "notes") as? String
        userName = dictionary.value(forKeyPath: "userName") as? String
    }
    
}
