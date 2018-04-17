//
//  PhotoViewController.swift
//  DesignJournal
//
//  Created by Ben Greene on 3/14/18.
//  Copyright © 2018 bfgreene. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    var newPhoto: UIImage?
    @IBOutlet var imageView: UIImageView!
    
    var saveOnly = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let availableImage = newPhoto {
            imageView.image = availableImage
        }
    }
    
    
    @IBAction func savePhoto(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: "Select a Tag:", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {_ in }
        let logoAction = UIAlertAction(title: "Logo", style: .default) {_ in self.writeImageData(withTag: "logo")}
        let typefaceAction = UIAlertAction(title: "Typeface", style: .default) {_ in self.writeImageData(withTag: "typeface") }
        let textureAction = UIAlertAction(title: "Texture", style: .default) {_ in self.writeImageData(withTag: "texture")}
        let layoutAction = UIAlertAction(title: "Layout", style: .default) {_ in self.writeImageData(withTag: "layout")}
        let miscAction = UIAlertAction(title: "Misc.", style: .default) {_ in self.writeImageData(withTag: "misc")}
        let noneAction = UIAlertAction(title: "None", style: .default) {_ in self.writeImageData(withTag: "none")}
        
        alertController.addAction(cancelAction)
        alertController.addAction(logoAction)
        alertController.addAction(typefaceAction)
        alertController.addAction(textureAction)
        alertController.addAction(layoutAction)
        alertController.addAction(miscAction)
        alertController.addAction(noneAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
        
    func writeImageData(withTag tag: String) {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    
        let pathEnding: Int = Int(Date().timeIntervalSince1970)
        let filePath = documentsURL.appendingPathComponent("\(pathEnding).png")
        
        if newPhoto != nil { newPhoto = newPhoto!.fixOrientation() }
        
        //create image data and write to filePath
        do {
            if let pngImageData = UIImagePNGRepresentation(newPhoto!) {
                try pngImageData.write(to: filePath, options: .atomic)
            }
        } catch {
            print("Error: could not write image")
        }
        
        let defaults = UserDefaults.standard
        
        var pathEndings = defaults.object(forKey: "pathEndings") as? [Int] ?? [Int]()
        pathEndings.append(pathEnding)
        defaults.set(pathEndings, forKey: "pathEndings")
        
        var tags = defaults.object(forKey: "tags") as? [String] ?? [String]()
        tags.append(tag)
        defaults.set(tags, forKey: "tags")
    
        if saveOnly {
            goBackToTabBar(self)
        } else {
            saveOnly = true
            self.performSegue(withIdentifier: "segueToPaletteCreator", sender: self)
        }
    }
    
    @IBAction func makePalette(_ sender: Any) {
        //send image to paletteCreatorVC
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {_ in }
        let saveAndPaletteAction = UIAlertAction(title: "Save Image and Create Palette", style: .default) {_ in
            self.saveOnly = false
            self.savePhoto(self)
        }
        let onlyPaletteAction = UIAlertAction(title: "Create Palette", style: .default) {_ in
           self.performSegue(withIdentifier: "segueToPaletteCreator", sender: self)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(onlyPaletteAction)
        alertController.addAction(saveAndPaletteAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func goBackToTabBar(_ sender: Any) {
        performSegue(withIdentifier: "unwindToTabBar", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToPaletteCreator",
            let nextScene = segue.destination as? PaletteCreatorViewController {
            nextScene.imageFromPhoto.image = self.imageView.image
        }
    }

}
