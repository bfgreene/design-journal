//
//  TabBarController.swift
//  DesignJournal
//
//  Created by Ben Greene on 3/12/18.
//  Copyright © 2018 bfgreene. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let addButton = UIButton.init(type: .custom)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeTabBar()
        self.view.insertSubview(addButton, aboveSubview: self.tabBar)
        addButton.addTarget(self, action: #selector(self.addButtonPressed(sender:)), for: .touchUpInside)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
          //  let topPadding = window?.safeAreaInsets.top
            let bottomPadding = window?.safeAreaInsets.bottom
            addButton.frame = CGRect.init(x: self.tabBar.center.x - 30, y: self.view.bounds.height - (47 + bottomPadding!), width: 50, height: 45)
        } else {
            addButton.frame = CGRect.init(x: self.tabBar.center.x - 30, y: self.view.bounds.height - 47, width: 50, height: 45)
        }
        addButton.layer.cornerRadius = 8
    }
    
    @IBAction func addButtonPressed(sender: UIButton) {
        //call UIAlert pop up menu from bottom -> Camera Roll or Camera
        let alertController = UIAlertController(title: nil, message: "New Image:", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {_ in }
        let cameraAction = UIAlertAction(title: "Use Camera", style: .default) {_ in
            self.performSegue(withIdentifier: "segueToCamera", sender: self)
        }
        let photosAction = UIAlertAction(title: "Add from Photos", style: .default) {_ in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self 
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(cameraAction)
        alertController.addAction(photosAction)

        /*
         * Uncomment for iPad use
        if let popoverPresentationController = alertController.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = self.view.bounds
        }
        */
        self.present(alertController, animated: true, completion: nil)
        
    }
   
    // Select image from photo library and go to PhotoVC
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        dismiss(animated: true, completion: nil)
        goToPhotoVC(withImage: image)
    }
    
    func customizeTabBar() {
        //TabBar and TabBar item appearance
        UITabBar.appearance().barTintColor = UIColor.white
        UITabBar.appearance().tintColor = UIColor.black
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular)], for: [.normal])
        
        //addButton styling
        addButton.setTitle("+", for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 35, weight: UIFontWeightThin)
        addButton.setTitleColor(UIColor.black, for: .normal)
        addButton.setTitleColor(UIColor.gray, for: .highlighted)
        addButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 5, 0)
        
        addButton.frame = CGRect(x: 100, y:0, width: 44, height: 44)
        addButton.backgroundColor = UIColor.white
        addButton.layer.borderColor = UIColor.black.cgColor
        addButton.layer.borderWidth = 1.5
    }
    
    func goToPhotoVC(withImage image: UIImage) {
        let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoVC") as! PhotoViewController
        photoVC.newPhoto = image
        DispatchQueue.main.async {
            self.present(photoVC, animated: false, completion: nil)
        }
    }
    
    @IBAction func unwindToTabBar(segue: UIStoryboardSegue) {}
    

}
