//
//  SharePhotoController.swift
//  InstagramFirebase
//
//  Created by Roman Salazar Lopez on 8/22/17.
//  Copyright © 2017 Roman Salazar Lopez. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController {
    
    var selectedImage: UIImage? {
        didSet {
            self.imageView.image = selectedImage
        }
    }
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let textView : UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(SharePhotoController.handleShareButton))
        setupImageAndTextViews()
    }
    
    fileprivate func setupImageAndTextViews() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        containerView.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 84, height: 0)
        containerView.addSubview(textView)
        textView.anchor(top: containerView.topAnchor, left: imageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    func handleShareButton() {
        guard let caption = textView.text, caption.characters.count > 0 else { return }
        guard let image = selectedImage else { return }
        guard let uploadData = UIImageJPEGRepresentation(image, 0.5) else { return }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let fileName = NSUUID().uuidString
        Storage.storage().reference().child("posts").child(fileName).putData(uploadData, metadata: nil) { (metaData, error) in
            if let error = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true

                print("Failed to upload image:", error)
                return
            }
            guard let imageURL = metaData?.downloadURL()?.absoluteString else { return }
                print("Success uploading image", imageURL)
            self.saveToDatabaseWithImageUrl(imageUrl: imageURL)
        }
    }
    
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
        guard let postImage = selectedImage else { return }
        let imageHeight = postImage.size.height
        let imageWidth = postImage.size.width
        
        guard let caption = textView.text else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userPostRef = Database.database().reference().child("posts").child(uid)
        let ref = userPostRef.childByAutoId()
        let values = ["imageUrl": imageUrl, "caption": caption, "imageHeight": imageHeight, "imageWidth": imageWidth, "creationDate": Date().timeIntervalSince1970] as [String : Any]
        ref.updateChildValues(values) { (error, reference) in
            if let error = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to save post to DB", error)
                return
            }
            print("Sucessfully saved post to DB", reference)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
