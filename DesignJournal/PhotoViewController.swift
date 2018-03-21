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
        
        let documentPath = documentsURL.path
        
        let date = Date()
        let pathEnding: Int = Int(date.timeIntervalSince1970)
        
        let filePath = documentsURL.appendingPathComponent("\(pathEnding).png")
        
        //check if path exists.. will crash shouldn't tho
        //from here
        do {
            let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
            
            for file in files {
                if "\(documentPath)/\(file)" == filePath.path {
                    try fileManager.removeItem(atPath: filePath.path)
                }
            }
        } catch {
            print("Error: could not save image")
        }
        // to here
        
        //create image data and write to filePath
        do {
            if let pngImageData = UIImagePNGRepresentation(newPhoto!) {
                try pngImageData.write(to: filePath, options: .atomic)
            }
        } catch {
            print("couldn't write image")
        }
        
    
        let newImage:ImageInfo = ImageInfo(path: filePath.path)
        ImagesData.images.append(newImage)
        
        let defaults = UserDefaults.standard
        var storedPaths = defaults.object(forKey: "images") as? [String] ?? [String]()
        storedPaths.append(filePath.path)
        
        defaults.set(storedPaths, forKey: "images")
        //defaults.synchronize()
        
        //do segue to gallery
        //self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "segueToJournal", sender: self)
        //then maybe go back to gallery too.. briefly display "saved" icon
    }
    
    
    //clear all files from directory.. move somewhere or use delete part
    //@IBAction func clearImagesCache(_ sender: Any) {
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
    
    
    @IBAction func goBack(_ sender: Any) {
        //clearImageCache() //if uncommenting, also clear userdefaults "images" array
        self.dismiss(animated: true, completion: nil)
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
