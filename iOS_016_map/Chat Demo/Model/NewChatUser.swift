//
//  NewChatUser.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 14/05/24.
//

import Foundation

struct NewChatUser {
    
    var name: String
    var email: String
    var profile: String?
    var uid: String
    
    init?(data: [String: Any]) {
        self.uid = data["uid"] as! String
        self.name = data["name"] as! String
        self.email = data["email"] as! String
        self.profile = data["profile"] as? String
    }
    
    init?(name: String, email: String, profile: String, uid: String) {
        self.uid = uid
        self.name = name
        self.profile = profile
        self.email = email
    }
    
}
