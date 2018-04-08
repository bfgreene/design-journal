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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let availableImage = newPhoto {
            imageView.image = availableImage
        }
    }
    
    
    @IBAction func savePhoto(_ sender: Any) {
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
//      let documentPath = documentsURL.path
        
    
        let pathEnding: Int = Int(Date().timeIntervalSince1970)
        let filePath = documentsURL.appendingPathComponent("\(pathEnding).png")
        
        //check if path exists.. will crash
//        do {
//            let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
//
//            for file in files {
//                if "\(documentPath)/\(file)" == filePath.path {
//                    try fileManager.removeItem(atPath: filePath.path)
//                }
//            }
//        } catch {
//            print("Error: could not save image")
//        }
        
        //create image data and write to filePath
        do {
            if let pngImageData = UIImagePNGRepresentation(newPhoto!) {
                try pngImageData.write(to: filePath, options: .atomic)
            }
        } catch {
            print("Error: could not write image")
        }
        
        
        let defaults = UserDefaults.standard
        var storedPaths = defaults.object(forKey: "images") as? [String] ?? [String]()
        storedPaths.append(filePath.path)
        
        defaults.set(storedPaths, forKey: "images")
        
        self.performSegue(withIdentifier: "segueToJournal", sender: self)
    }
    
    
    //clear all files from directory.. move somewhere or use delete part
    func clearImageCache() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentPath = documentsURL.path
        
        do {
            let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
            print("files in /Documents/: \(files.count)")
            for file in files {
                try fileManager.removeItem(atPath: "\(documentPath)/\(file)")
            }
        } catch {
            print("Error: could not clear cache")
        }
    }
    
    @IBAction func makePalette(_ sender: Any) {
        //send image to paletteCreatorVC
        self.performSegue(withIdentifier: "segueToPaletteCreator", sender: self)
    }
    
    
    
    @IBAction func goBack(_ sender: Any) {
        //clearImageCache() //if uncommenting, also clear userdefaults "images" array
        self.dismiss(animated: true, completion: nil)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToPaletteCreator",
            let nextScene = segue.destination as? PaletteCreatorViewController {
            nextScene.imageFromPhoto.image = self.imageView.image
        }
    }
    

}
