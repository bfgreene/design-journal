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
    var selectedImage: UIImage = UIImage.init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        UITabBar.appearance().barTintColor = UIColor.white
        UITabBar.appearance().tintColor = UIColor.black
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 15)], for: [.normal])

        addButton.setTitle("+", for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        addButton.setTitleColor(UIColor.black, for: .normal)
        addButton.setTitleColor(UIColor.gray, for: .highlighted)
        addButton.frame = CGRect(x: 100, y:0, width: 44, height: 44)
        addButton.backgroundColor = UIColor.white
        addButton.layer.borderColor = UIColor.black.cgColor
        addButton.layer.borderWidth = 3
        self.view.insertSubview(addButton, aboveSubview: self.tabBar)
        
        addButton.addTarget(self, action: #selector(self.addButtonPressed(sender:)), for: .touchUpInside)
        
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addButton.frame = CGRect.init(x: self.tabBar.center.x - 32, y: self.view.bounds.height - 74, width: 64, height: 64)
        addButton.layer.cornerRadius = 32
    }
    
    @IBAction func addButtonPressed(sender: UIButton) {
        //call UIAlert pop up menu from bottom -> Camera Roll or Camera
        let alertController = UIAlertController(title: nil, message: "Towels.", preferredStyle: .actionSheet)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            //cancel
        }
        let cameraAction = UIAlertAction(title: "Use Camera", style: .default) { action in
            //go to cameraVC
            self.performSegue(withIdentifier: "segueToCamera", sender: self)
        }
        let photosAction = UIAlertAction(title: "Add from Photos", style: .default) { action in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self 
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(cameraAction)
        alertController.addAction(photosAction)
        
        self.present(alertController, animated: true) {}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToCamera" {
            /** send information***
            if let destination = segue.destination as? Modo1ViewController {
                destination.nomb = nombres // you can pass value to destination view controller
            }
            */
        }
    }

    func goToPhotoVC() {
        let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoVC") as! PhotoViewController
        photoVC.newPhoto = self.selectedImage //image from camera roll
        DispatchQueue.main.async {
            self.present(photoVC, animated: false, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        selectedImage = image
        dismiss(animated: true, completion: nil)
        goToPhotoVC()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
