//
//  ViewController.swift
//  DesignJournal
//
//  Created by Ben Greene on 3/9/18.
//  Copyright © 2018 bfgreene. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    let pathBeginning = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    var pathEndings = [Int]()
    var tags = [String]()
    var filteredIndexes = [Int]()
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var topMenuView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterImages(withTag: "none", withText: "All")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //TODO: instead of reloading on willAppear, only reload if data has changed.. or hopefully add new data without reloading old data that changed
        //TODO: maintain or reset filter on appear.. not consistent
        pathEndings = UserDefaults.standard.array(forKey: "pathEndings") as? [Int] ?? [Int]()
        tags = UserDefaults.standard.stringArray(forKey: "tags") ?? [String]()
        filteredIndexes = Array(0..<tags.count)
        
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredIndexes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath as IndexPath) as! CustomCollectionViewCell
        
        let nextIndex = filteredIndexes[indexPath.row]
        
        let pathEnd = "\(pathEndings[nextIndex]).png"
        let filePath = pathBeginning.appendingPathComponent(pathEnd)
        
        if FileManager.default.fileExists(atPath: filePath.path) {
            let contentsOfFilePath = UIImage(contentsOfFile: filePath.path)
            let rotatedImage = UIImage(cgImage: (contentsOfFilePath?.cgImage)!, scale: 1.0, orientation: .right) //PNGs not auto-rotated
            cell.cellImageView.image = rotatedImage
        }
        
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Calculations to find cell width for n cells/row, here n=3
        let cellsAcross: CGFloat = 3
        let spaceBetweenCells: CGFloat = 1
        let dim = (collectionView.bounds.width - (cellsAcross - 1) * spaceBetweenCells) / cellsAcross
        return CGSize(width: dim, height: dim)
    }

    // change background color when user touches cell
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CustomCollectionViewCell
        cell.cellImageView.backgroundColor = UIColor.black
        cell.cellImageView.layer.opacity = 0.7
    }
    
    // change background color back when user releases touch
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CustomCollectionViewCell
        cell.cellImageView.layer.opacity = 1.0
    }
    
    
    
    @IBAction func selectFilter(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: "Filter by:", preferredStyle: .actionSheet)
        let allAction = UIAlertAction(title: "All", style: .default) {_ in self.filterImages(withTag: "none", withText: "All")}
        let logoAction = UIAlertAction(title: "Logo", style: .default) {_ in self.filterImages(withTag: "logo", withText: "Logo")}
        let typefaceAction = UIAlertAction(title: "Typeface", style: .default) {_ in self.filterImages(withTag: "typeface", withText: "Typeface")}
        let textureAction = UIAlertAction(title: "Texture", style: .default) {_ in self.filterImages(withTag: "texture", withText: "Texture")}
        let layoutAction = UIAlertAction(title: "Layout", style: .default) {_ in self.filterImages(withTag: "layout", withText: "Layout")}
        let miscAction = UIAlertAction(title: "Misc.", style: .default) {_ in self.filterImages(withTag: "misc", withText: "Misc.")}
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {_ in }
        
        alertController.addAction(allAction)
        alertController.addAction(logoAction)
        alertController.addAction(typefaceAction)
        alertController.addAction(textureAction)
        alertController.addAction(layoutAction)
        alertController.addAction(miscAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func filterImages(withTag tag: String, withText text:String) {
        styleFilterButton(withText: text)
        
        if tag == "none" {
            filteredIndexes = Array(0..<tags.count)
        } else {
            filteredIndexes = []
            for (index, item) in tags.enumerated() {
                if item == tag { filteredIndexes.append(index) }
            }
        }
        
        collectionView.reloadData()
        if filteredIndexes.count > 0 {
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionViewScrollPosition.top, animated: true)
        }
    }
    
    func styleFilterButton(withText text: String) {
        filterButton.backgroundColor = .clear
        //filterButton.layer.cornerRadius = 15
        filterButton.layer.borderWidth = 1.5
        filterButton.layer.borderColor = UIColor.darkGray.cgColor
        filterButton.titleLabel?.textColor = .darkGray
        
        filterButton.setTitle("Filter: \(text)", for: .normal)
        filterButton.contentEdgeInsets = UIEdgeInsetsMake(5.0, 10.0, 5.0, 10.0)
        filterButton.sizeToFit()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier ==  "segueToImageDetail" {
            if let selectedCell = collectionView.indexPathsForSelectedItems?.first {
                let nextScene = segue.destination as! ImageDetailViewController
                let cell = collectionView.cellForItem(at: selectedCell) as! CustomCollectionViewCell
                if let image = cell.cellImageView.image {
                    nextScene.imageFromCollection = image
                }
                let index = collectionView.indexPath(for: cell)?.row
                nextScene.imageIndex = index!
            }
        }
    }
}
