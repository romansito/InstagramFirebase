//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Roman Salazar Lopez on 8/7/17.
//  Copyright © 2017 Roman Salazar Lopez. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            // create new log in page and present it here
        }
        
        
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        let navigationController = UINavigationController(rootViewController: userProfileController)
        
        navigationController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        navigationController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        
        tabBar.tintColor = .black
        
        viewControllers = [navigationController, UIViewController()]
    }
}
