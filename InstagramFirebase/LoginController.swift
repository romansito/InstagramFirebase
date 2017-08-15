//
//  LoginController.swift
//  InstagramFirebase
//
//  Created by Roman Salazar Lopez on 8/15/17.
//  Copyright © 2017 Roman Salazar Lopez. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Don't have an account? Sign Up.", for: .normal)
        button.addTarget(self, action: #selector(LoginController.handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    func handleShowSignUp() {
        let signupController = SignUpController()
        navigationController?.pushViewController(signupController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(signupButton)
        signupButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
    }
}
