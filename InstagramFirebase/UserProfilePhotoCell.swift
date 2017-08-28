//
//  UserProfilePhotoCell.swift
//  InstagramFirebase
//
//  Created by Roman Salazar Lopez on 8/25/17.
//  Copyright © 2017 Roman Salazar Lopez. All rights reserved.
//

import UIKit

class UserProfilePhotoCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            guard let imageUrl = post?.imageUrl else { return }
            guard let url = URL(string: imageUrl) else { return }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error getting image for post from url", error)
                    return
                }
                guard let imageData = data else {return}
                let photoImage = UIImage(data: imageData)
                DispatchQueue.main.async {
                    self.photoImage.image = photoImage
                }
            }.resume()
        }
    }
    
    let photoImage : UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(photoImage)
        photoImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
