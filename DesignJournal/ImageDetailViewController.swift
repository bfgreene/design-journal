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
    var imageIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = imageFromCollection
    }
    
    
    @IBAction func createPalettePushed(_ sender: Any) {
        self.performSegue(withIdentifier: "segueToCreatePalette", sender: self)
    }
    
    
    @IBAction func trashButtonPushed(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: "Delete this item?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {_ in }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive){_ in
                self.deleteImage()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteImage() {
        
        var pathEndings = UserDefaults.standard.array(forKey: "pathEndings") as? [Int]
        pathEndings?.remove(at: imageIndex)
        var tags = UserDefaults.standard.stringArray(forKey: "tags")
        tags?.remove(at: imageIndex)
        
        UserDefaults.standard.set(pathEndings, forKey: "pathEndings")
        UserDefaults.standard.set(tags, forKey: "tags")
        
        goBack(self)
        
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToCreatePalette",
            let paletteCreatorVC = segue.destination as? PaletteCreatorViewController {
            paletteCreatorVC.imageFromPhoto.image = self.imageView.image
        }
    }
}
