//
//  ChatUser.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 16/05/24.
//

import Foundation
import FirebaseFirestore

struct ChatUser {
    
    var name: String
    var email: String
    var profile: String?
    var uid: String
    var last_message: String?
    var time: Timestamp?
    
    init?(data: [String: Any]) {
        self.uid = data["uid"] as! String
        self.name = data["name"] as! String
        self.email = data["email"] as! String
        self.profile = data["profile"] as? String
        self.last_message = data["last_message"] as? String
        self.time = data["time"] as? Timestamp
    }
    
    init?(name: String, email: String, profile: String?, uid: String, time: Timestamp?, lastMessage: String?) {
        self.uid = uid
        self.name = name
        self.email = email
        
        if let profile = profile {
            self.profile = profile
        }
        if let lastMessage = lastMessage, let time = time {
            self.last_message = lastMessage
            self.time = time
        }
    }
    
}
