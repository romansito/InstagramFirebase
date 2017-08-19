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
        //Home
        let homeNavigationController = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()))
    
        //Search
        let searchNavigationController = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"))
        
        //plus
        let plusNavigationController = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))
        
        //Like
        let likeNavigationController = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"))
        
        //Profile
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        let userProfileNavigationController = UINavigationController(rootViewController: userProfileController)
        userProfileNavigationController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        userProfileNavigationController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        //
        tabBar.tintColor = .black
        viewControllers = [homeNavigationController, searchNavigationController, plusNavigationController, likeNavigationController, userProfileNavigationController]
        
        //modify tabbar item insets
        guard let items = tabBar.items else {return}
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    fileprivate func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = UIViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = unselectedImage
        navigationController.tabBarItem.selectedImage = selectedImage
        return navigationController
    }
}
