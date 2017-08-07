//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Roman Salazar Lopez on 8/7/17.
//  Copyright © 2017 Roman Salazar Lopez. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        let redVC = UIViewController()
        redVC.view.backgroundColor = .red
    
        let navigationController = UINavigationController(rootViewController: redVC)
        
       
        
        
        
        viewControllers = [navigationController]
    }
}
