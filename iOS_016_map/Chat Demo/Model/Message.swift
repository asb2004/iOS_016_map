//
//  Message.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 14/05/24.
//

import Foundation
import FirebaseFirestore

struct Message : Codable {
    
    var mid: String
    var message: String
    var type: String
    var time: Timestamp
    var senderID: String
    var receiverID: String
    var isDeletedForMe: Bool
    var isDeletedForEveryone: Bool
    
    init?(data: [String: Any]) {
        
        self.mid = data["mid"] as! String
        self.message = data["message"] as! String
        self.type = data["type"] as! String
        self.time = data["time"] as! Timestamp
        self.senderID = data["senderID"] as! String
        self.receiverID = data["receiverID"] as! String
//        self.isDeletedForMe = data["isDeletedForMe"] as! Bool
//        self.isDeletedForEveryone = data["isDeletedForEveryone"] as! Bool
        
        if let isDeletedForMe = data["isDeletedForMe"] as? Bool {
            self.isDeletedForMe = isDeletedForMe
        } else {
            self.isDeletedForMe = false
        }

        if let isDeletedForEveryone = data["isDeletedForEveryone"] as? Bool {
            self.isDeletedForEveryone = isDeletedForEveryone
        } else {
            self.isDeletedForEveryone = false
        }
        
    }
    
    init?(mid: String, message: String, type: String, time: Timestamp, senderID: String, receiverID: String, isDeletedForMe: Bool, isDeletedForEveryone: Bool) {
        
        self.mid = mid
        self.message = message
        self.type = type
        self.time = time
        self.senderID = senderID
        self.receiverID = receiverID
        self.isDeletedForMe = isDeletedForMe
        self.isDeletedForEveryone = isDeletedForEveryone
    }
    
}
