//
//  User.swift
//  InstagramFirebase
//
//  Created by Roman Salazar Lopez on 9/1/17.
//  Copyright © 2017 Roman Salazar Lopez. All rights reserved.
//

import Foundation

struct User {
    let username: String
    let profileImageUrl: String
    
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"]  as? String ?? ""
    }
}

