//
//  Post.swift
//  InstagramFirebase
//
//  Created by Roman Salazar Lopez on 8/25/17.
//  Copyright © 2017 Roman Salazar Lopez. All rights reserved.
//

import Foundation

struct Post {
    
    let user: User
    let imageUrl: String
    let caption: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
    }
}
