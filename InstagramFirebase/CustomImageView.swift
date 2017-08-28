//
//  CustomImageView.swift
//  InstagramFirebase
//
//  Created by Roman Salazar Lopez on 8/28/17.
//  Copyright © 2017 Roman Salazar Lopez. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    
    func loadImage(urlString: String) {
        print("Loading image...")
        
        lastURLUsedToLoadImage = urlString
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error getting image for post from url", error)
                return
            }
            
            // prevents from images to reload more than once.
            if url.absoluteString != self.lastURLUsedToLoadImage {
                return
            }
            
            guard let imageData = data else {return}
            let photoImage = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.image = photoImage
            }
        }.resume()
    }
}
