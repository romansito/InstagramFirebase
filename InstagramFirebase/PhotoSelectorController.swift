
//
//  PhotoSelecterController.swift
//  InstagramFirebase
//
//  Created by Roman Salazar Lopez on 8/19/17.
//  Copyright © 2017 Roman Salazar Lopez. All rights reserved.
//

import UIKit

class PhotoSelectorController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .yellow
        
        setupNavigationButtons()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate func setupNavigationButtons() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(PhotoSelectorController.gentleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(PhotoSelectorController.gentleNextButton))
    }
    
    func gentleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func gentleNextButton() {
        print("Handleing next")
    }
    
}
