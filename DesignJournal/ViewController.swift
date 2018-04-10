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
    
    @IBOutlet var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //TODO: instead of reloading on willAppear, only reload if data has changed.. or hopefully add new data without reloading old data that changed
       
        pathEndings = UserDefaults.standard.array(forKey: "pathEndings") as? [Int] ?? [Int]()
        tags = UserDefaults.standard.stringArray(forKey: "tags") ?? [String]()
        
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pathEndings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath as IndexPath) as! CustomCollectionViewCell
        
        let pathEnd = "\(pathEndings[indexPath.row]).png"
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier ==  "segueToImageDetail" {
            if let selectedCell = collectionView.indexPathsForSelectedItems?.first{
                let nextScene = segue.destination as! ImageDetailViewController
                let cell = collectionView.cellForItem(at: selectedCell) as! CustomCollectionViewCell
                if let image = cell.cellImageView.image {
                    nextScene.imageFromCollection = image
                }
            }
        }
    }
}
