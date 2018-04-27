//
//  ViewController.swift
//  DesignJournal
//
//  Created by Ben Greene on 3/9/18.
//  Copyright © 2018 bfgreene. All rights reserved.
//

import UIKit

class JournalViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var topMenuView: UIView!
    
    var newImageTag: String?
    var deletedImageIndex: Int?
    var updatedTag: String?
    var filteredIndex: Int?
    var currentFilter: String?
    var currentFilterText: String?
    
    var imageCache = [Int : UIImage]()
    
    let pathBeginning = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    var pathEndings = [Int]()
    var tags = [String]()
    var filteredIndexes = [Int]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currentFilter == nil {
            filterImages(withTag: "none", withText: "All")
        }
        
        pathEndings = UserDefaults.standard.array(forKey: "pathEndings") as? [Int] ?? [Int]()
        tags = UserDefaults.standard.stringArray(forKey: "tags") ?? [String]()
        filteredIndexes = Array(0..<tags.count)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pathEndings = UserDefaults.standard.array(forKey: "pathEndings") as? [Int] ?? [Int]()
        tags = UserDefaults.standard.stringArray(forKey: "tags") ?? [String]()
        
        //only reload data if new image added and it should be displayed based on filter
        if newImageTag != nil {
            if newImageTag == currentFilter || currentFilter == "none" {
                filteredIndexes.append(tags.count-1)
                newImageTag = nil
                collectionView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(filteredIndexes.count > 12) {
            let path = IndexPath(item: filteredIndexes.count-1, section: 0)
            collectionView.scrollToItem(at: path, at: .bottom, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredIndexes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath as IndexPath) as! CustomCollectionViewCell
        
        let nextIndex = filteredIndexes[indexPath.row]
        
        let pathEnd = "\(pathEndings[nextIndex]).png"
        let filePath = pathBeginning.appendingPathComponent(pathEnd)
        
        if let image = imageCache[pathEndings[nextIndex]] {
            cell.cellImageView.image = image
        } else {
            if FileManager.default.fileExists(atPath: filePath.path) {
                let contentsOfFilePath = UIImage(contentsOfFile: filePath.path)
                imageCache[pathEndings[nextIndex]] = contentsOfFilePath
                cell.cellImageView.image = contentsOfFilePath
            }
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
        let patternAction = UIAlertAction(title: "Pattern", style: .default) {_ in self.filterImages(withTag: "pattern", withText: "Pattern")}
        let layoutAction = UIAlertAction(title: "Layout", style: .default) {_ in self.filterImages(withTag: "layout", withText: "Layout")}
        let miscAction = UIAlertAction(title: "Misc.", style: .default) {_ in self.filterImages(withTag: "misc", withText: "Misc.")}
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {_ in }
        
        alertController.addAction(allAction)
        alertController.addAction(logoAction)
        alertController.addAction(typefaceAction)
        alertController.addAction(patternAction)
        alertController.addAction(layoutAction)
        alertController.addAction(miscAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //reload images with only selcted filter, scroll to bottom
    func filterImages(withTag tag: String, withText text:String) {
        styleFilterButton(withText: text)
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        currentFilter = tag
        currentFilterText = text
        
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
            collectionView.scrollToItem(at: IndexPath(item: filteredIndexes.count-1, section: 0), at: .bottom, animated: true)
        }
        UIViewController.removeSpinner(spinner: sv)
    }
    
    func styleFilterButton(withText text: String) {
        filterButton.backgroundColor = .clear
        filterButton.layer.borderWidth = 1.5
        filterButton.layer.borderColor = UIColor.darkGray.cgColor
        filterButton.titleLabel?.textColor = .darkGray
        
        filterButton.setTitle("Filter: \(text)", for: .normal)
        filterButton.contentEdgeInsets = UIEdgeInsetsMake(5.0, 10.0, 5.0, 10.0)
        filterButton.sizeToFit()
    }
    
    @IBAction func unwindtoJournalVC(segue: UIStoryboardSegue) {
        
        
        if updatedTag != nil, currentFilter != "none" {
            filterImages(withTag: currentFilter!, withText: currentFilterText!)
            updatedTag = nil
        }
        
        
        if deletedImageIndex != nil {
            tags.remove(at: deletedImageIndex!)
            if imageCache[pathEndings[deletedImageIndex!]] != nil {
                imageCache[pathEndings[deletedImageIndex!]] = nil
            }
            pathEndings.remove(at: deletedImageIndex!)
            //pathEndings = UserDefaults.standard.array(forKey: "pathEndings") as? [Int] ?? [Int]()
            filterImages(withTag: currentFilter!, withText: currentFilterText!)
            deletedImageIndex = nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier ==  "segueToImageDetail" {
            if let selectedCell = collectionView.indexPathsForSelectedItems?.first {
                let imageDetailVC = segue.destination as! ImageDetailViewController
                let cell = collectionView.cellForItem(at: selectedCell) as! CustomCollectionViewCell
                if let image = cell.cellImageView.image {
                    imageDetailVC.imageFromCollection = image
                }
                //giving the index of it filtered not in tags/paths arrays
                let index = collectionView.indexPath(for: cell)?.row
                imageDetailVC.imageIndex = filteredIndexes[index!]
                imageDetailVC.originalTag = currentFilter!
                filteredIndex = index!
            }
        }
    }
}
