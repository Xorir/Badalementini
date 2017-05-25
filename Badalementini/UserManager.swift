//
//  UserManager.swift
//  Badalementini
//
//  Created by Lord Summerisle on 5/15/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import Foundation
import Firebase

class UserManager: NSObject {
    
    static let sharedInstance = UserManager()
    
    var ref: FIRDatabaseReference!
    var _refHandle: FIRDatabaseHandle!
    
}
