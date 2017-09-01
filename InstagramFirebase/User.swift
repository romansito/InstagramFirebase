//
//  User.swift
//  InstagramFirebase
//
//  Created by Roman Salazar Lopez on 9/1/17.
//  Copyright © 2017 Roman Salazar Lopez. All rights reserved.
//

import Foundation

struct User {
    
    let uid: String
    let username: String
    let profileImageUrl: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"]  as? String ?? ""
    }
}

