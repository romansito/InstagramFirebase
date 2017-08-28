//
//  Post.swift
//  InstagramFirebase
//
//  Created by Roman Salazar Lopez on 8/25/17.
//  Copyright © 2017 Roman Salazar Lopez. All rights reserved.
//

import Foundation

struct Post {
    let imageUrl: String
    
    init(dictionary: [String: Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
}
