//
//  ImageDetailViewController.swift
//  DesignJournal
//
//  Created by Ben Greene on 3/13/18.
//  Copyright © 2018 bfgreene. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {

    
    @IBOutlet var imageView: UIImageView!
    var imageFromCollection = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = imageFromCollection
    }

    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
