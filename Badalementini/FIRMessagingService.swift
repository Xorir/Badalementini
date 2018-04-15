//
//  FIRMessagingService.swift
//  Badalementini
//
//  Created by Lord Summerisle on 4/14/18.
//  Copyright © 2018 ErmanMaris. All rights reserved.
//

import Foundation
import FirebaseMessaging

class FIRMessagingSevice {
    
    private init() {}
    static let shared = FIRMessagingSevice()
    let messaging = Messaging.messaging()
    
    func subscribe(to topic: String) {
        messaging.subscribe(toTopic: topic)
    }
    
    func unSubscribe(from topic: String) {
        messaging.unsubscribe(fromTopic: topic)
    }
}
