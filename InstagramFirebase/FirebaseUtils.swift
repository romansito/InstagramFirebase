//
//  FirebaseUtils.swift
//  InstagramFirebase
//
//  Created by Roman Salazar Lopez on 9/1/17.
//  Copyright © 2017 Roman Salazar Lopez. All rights reserved.
//

import Foundation
import Firebase

extension Database {
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
        print("Fet hing user with uid:", uid)
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)
        }) { (error) in
            print("Failed to fetch users posts", error)
        }
    }
}
