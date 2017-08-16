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
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navigationController = UINavigationController(rootViewController: loginController)
                self.present(navigationController, animated: true, completion: nil)
            }
            return
        }
        
      setupViewControllers()
    }
    
    func setupViewControllers() {
        let layout = UICollectionViewFlowLayout()
        
        //Home
        let homeController = UIViewController()
        let homeNavigationController = UINavigationController(rootViewController: homeController)
        homeNavigationController.tabBarItem.image = #imageLiteral(resourceName: "home_unselected")
        homeNavigationController.tabBarItem.selectedImage = #imageLiteral(resourceName: "home_selected")
        
        //Profile
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        let profileNavigationController = UINavigationController(rootViewController: userProfileController)
        
        profileNavigationController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        profileNavigationController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        
        tabBar.tintColor = .black
        
        viewControllers = [homeNavigationController, profileNavigationController]
    }
}
