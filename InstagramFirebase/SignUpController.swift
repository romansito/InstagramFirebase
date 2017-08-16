//
//  ViewController.swift
//  InstagramFirebase
//
//  Created by Roman Salazar Lopez on 8/2/17.
//  Copyright © 2017 Roman Salazar Lopez. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(SignUpController.handleAddPlusPhoto), for: .touchUpInside)
        return button
    }()
    
    func handleAddPlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            plusButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            plusButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        plusButton.layer.cornerRadius = plusButton.frame.width/2
        plusButton.layer.masksToBounds = true
        dismiss(animated: true, completion: nil)
    }
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.backgroundColor = UIColor.init(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return textField
    }()
    
    let userNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.backgroundColor = UIColor.init(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor.init(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return textField
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244, alpha: 1)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = false
        
        return button
    }()
    
    func handleSignUp() {
        let isFormValid = emailTextField.text?.characters.count ?? 0 > 0 && userNameTextField.text?.characters.count ?? 0 > 0 && passwordTextField.text?.characters.count ?? 0 > 0
        
        if isFormValid {
            //
        } else {
            signUpButton.isEnabled = false
            showAlerForIncompleteForm()
        }
        
        guard let email = emailTextField.text, email.characters.count > 0 else { return }
        guard let username = userNameTextField.text, username.characters.count > 0 else { return }
        guard let password = passwordTextField.text, password.characters.count > 0 else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user: Firebase.User?, error: Error?) in
            if error == nil {
                guard let image = self.plusButton.imageView?.image else {return}
                guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else {return}
                
                let filename = NSUUID().uuidString
                
                Storage.storage().reference().child("profile_images").child(filename).putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if let error = error {
                        print("Filaed to upload profile image", error)
                        return
                    }
                    guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else {return}
                    print("Sucessfully uploaded profile image:", profileImageUrl)
                    
                    guard let uid = user?.uid else {return}
                    let dictionaryValues = ["username": username, "profileImageUrl": profileImageUrl]
                    let values = [uid: dictionaryValues]
                    Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error, reference) in
                        if let error = error {
                            print("Failed to save user info into db:", error)
                            return
                        }
                        print("Successfully saved user info to db")
                        guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {return}
                        mainTabBarController.setupViewControllers()
                        
                        self.dismiss(animated: true, completion: nil)
                    })
                    print("Successfully created user:", user?.uid ?? "")
                })
            } else if let errCode = AuthErrorCode(rawValue: (error!._code)) {
                switch errCode {
                case .emailAlreadyInUse:
                    self.showAlertForDuplicatedEmailAddress()
                    print("The email is already in use with another account")
                case .userDisabled:
                    print("Your account has been disabled. Please contact support.")
                case .invalidEmail, .invalidSender, .invalidRecipientEmail:
                    self.showAlertForInvalidEmailAddress()
                    print("Please enter a valid email")
                case .networkError:
                    print("Network error. Please try again.")
                case .weakPassword:
                    self.showAlertForInvalidPassword()
                    print("Your password is too weak")
                default:
                    print("Unknown error occurred")
                }
                return
            }
        }
    }
    
    func handleTextInputChange() {
        
        signUpButton.isEnabled = true
        
        let isFormValid = emailTextField.text?.characters.count ?? 0 > 0 && userNameTextField.text?.characters.count ?? 0 > 0 && passwordTextField.text?.characters.count ?? 0 > 0
        
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237, alpha: 1)
        } else {
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244, alpha: 1)
        }
    }
    
    func showAlertForInvalidPassword() {
        let alertViewController = UIAlertController(title: "Almost there", message: "Password must be at least 6 characters long", preferredStyle: .alert)
        let okAlert = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertViewController.addAction(okAlert)
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    fileprivate func showAlerForIncompleteForm() {
        let alertViewController = UIAlertController(title: "Almost there", message: "Please complete the form", preferredStyle: .alert)
        let okAlert = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertViewController.addAction(okAlert)
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    fileprivate func showAlertForInvalidEmailAddress() {
        let alertViewController = UIAlertController(title: "Invalid Email Address", message: "Please enter a valid email address", preferredStyle: .alert)
        let okAlert = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertViewController.addAction(okAlert)
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    fileprivate func showAlertForDuplicatedEmailAddress() {
        let alertViewController = UIAlertController(title: "Invalid Email Address", message: "It looks like this email address is already been used. Please sign in", preferredStyle: .alert)
        let okAlert = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertViewController.addAction(okAlert)
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Don't have an account? Sign Up.", for: .normal)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.rgb(red: 17, green: 154, blue: 237, alpha: 1)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(SignUpController.handleAlreadyHaveAccount), for: .touchUpInside)
        return button
    }()
    
    func handleAlreadyHaveAccount() {
        navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        view.backgroundColor = .white
        setupPlusButton()
        setupInputFields()
    }
    
    fileprivate func setupPlusButton() {
        view.addSubview(plusButton)
        
        plusButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        plusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    fileprivate func setupInputFields() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, userNameTextField, passwordTextField, signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        
        stackView.anchor(top: plusButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
    }
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,  paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}





