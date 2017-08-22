//
//  SharePhotoController.swift
//  InstagramFirebase
//
//  Created by Roman Salazar Lopez on 8/22/17.
//  Copyright © 2017 Roman Salazar Lopez. All rights reserved.
//

import UIKit

class SharePhotoController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(SharePhotoController.handleShareButton))
    }
    
    func handleShareButton() {
        
    }
    
}
