//
//  File.swift
//  Badalementini
//
//  Created by Lord Summerisle on 5/15/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import Foundation

class AppState: NSObject {
    
    static let sharedInstance = AppState()
    
    var signedIn = false
    var isFaceBookUser = false
    var displayName: String?
    var photoUrl: URL?
    var UID: String?
}
