//
//  FIRMessagingService.swift
//  Badalementini
//
//  Created by Lord Summerisle on 3/31/18.
//  Copyright © 2018 ErmanMaris. All rights reserved.
//

import Foundation
import FirebaseMessaging

enum SubscriptionTopic: String {
    case newProducts = "newProducts"
}

class FIRMessagingService {
    private init() {}
    static let shared = FIRMessagingService()
    let messaging = Messaging.messaging()
    
    func subscribe(to topic: SubscriptionTopic, deviceToken: Data) {
        messaging.apnsToken = deviceToken
        messaging.subscribe(toTopic: topic.rawValue)
    }
    
    func unsubscribe(from topic: SubscriptionTopic) {
        messaging.unsubscribe(fromTopic: topic.rawValue)
    }
}
