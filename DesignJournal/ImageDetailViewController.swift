//
//  ImageDetailViewController.swift
//  DesignJournal
//
//  Created by Ben Greene on 3/13/18.
//  Copyright © 2018 bfgreene. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController, UIScrollViewDelegate {

    
    @IBOutlet var imageView: UIImageView!
    var imageFromCollection = UIImage()
    var imageIndex = 0
    var tagChanged = false
    
    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = imageFromCollection
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
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
        
        //remove from file system
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentPath = documentsURL.appendingPathComponent("\(pathEndings![imageIndex]).png").path
        do {
            try fileManager.removeItem(atPath: "\(documentPath)")
        } catch {
            print("Error: could not delete image")
        }
        
        //remove path endings and tags
        pathEndings?.remove(at: imageIndex)
        var tags = UserDefaults.standard.stringArray(forKey: "tags")
        tags?.remove(at: imageIndex)
        
        UserDefaults.standard.set(pathEndings, forKey: "pathEndings")
        UserDefaults.standard.set(tags, forKey: "tags")
    
        goBackToJournal(self)
    }
    
    
    @IBAction func retagButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: "Select a Tag:", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {_ in }
        let logoAction = UIAlertAction(title: "Logo", style: .default) {_ in self.retagImage(withTag: "logo")}
        let typefaceAction = UIAlertAction(title: "Typeface", style: .default) {_ in self.retagImage(withTag: "typeface") }
        let textureAction = UIAlertAction(title: "Texture", style: .default) {_ in self.retagImage(withTag: "texture")}
        let layoutAction = UIAlertAction(title: "Layout", style: .default) {_ in self.retagImage(withTag: "layout")}
        let miscAction = UIAlertAction(title: "Misc.", style: .default) {_ in self.retagImage(withTag: "misc")}
        let noneAction = UIAlertAction(title: "None", style: .default) {_ in self.retagImage(withTag: "none")}
        
        alertController.addAction(cancelAction)
        alertController.addAction(logoAction)
        alertController.addAction(typefaceAction)
        alertController.addAction(textureAction)
        alertController.addAction(layoutAction)
        alertController.addAction(miscAction)
        alertController.addAction(noneAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func retagImage(withTag tag: String) {
        let defaults = UserDefaults.standard
        var tags = defaults.object(forKey: "tags") as? [String]
        if tags != nil {
            tags![imageIndex] = tag
            defaults.set(tags, forKey: "tags")
            tagChanged = true
        } else {
            print("Error: could not change tag")
        }
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    @IBAction func goBackToJournal(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToJournal", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToCreatePalette",
            let paletteCreatorVC = segue.destination as? PaletteCreatorViewController {
            paletteCreatorVC.imageFromPhoto.image = self.imageView.image
        } else if segue.identifier == "unwindSegueToJournal",
            let journalVC = segue.destination as? JournalViewController {
            if tagChanged { journalVC.shouldUpdateData = true }
            tagChanged = false
        }
    }
}
