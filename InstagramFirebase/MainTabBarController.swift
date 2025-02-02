//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Roman Salazar Lopez on 8/7/17.
//  Copyright © 2017 Roman Salazar Lopez. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.index(of: viewController)
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            let navigationController = UINavigationController(rootViewController: photoSelectorController)
            present(navigationController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
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
        let homeNavigationController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
    
        //Search
        let searchNavigationController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"))
        
        //plus
        let plusNavigationController = templateNavController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))
        
        //Like
        let likeNavigationController = templateNavController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"))
        
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
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
}
