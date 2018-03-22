//
//  ViewController.swift
//  DesignJournal
//
//  Created by Ben Greene on 3/9/18.
//  Copyright © 2018 bfgreene. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    var imagesFromDefaults: Array<String> = []
    
    @IBOutlet var collectionView: UICollectionView!
    let  reuseIdentifier = "customCell"
    var images2 = ["dtla-pink", "dtop_bground", "dtop", "faroe_islands", "iceland", "maldives_beach", "malign_lake", "mtBaker_BC", "mthood", "mtJefferson_OR", "myanmar", "sf_rock", "switz_oss", "yosemite_falls", "yosemite_valley", "dtla-pink", "dtop_bground", "dtop", "faroe_islands", "iceland", "maldives_beach", "malign_lake", "mtBaker_BC", "mthood", "mtJefferson_OR", "myanmar", "sf_rock", "switz_oss", "yosemite_falls", "yosemite_valley" ]
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let count = ImagesData.images.count
//        imagesDataLabel.text = "ImagesData: \(count)"
        imagesFromDefaults = UserDefaults.standard.stringArray(forKey: "images") ?? [String]()
        collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesFromDefaults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CustomCollectionViewCell
        
        
        let filePath = imagesFromDefaults[indexPath.row]
        if FileManager.default.fileExists(atPath: filePath) {
            let contentsOfFilePath = UIImage(contentsOfFile: filePath)
            cell.cellImageView.image = contentsOfFilePath
        }
        
        return cell
    }

    
    
   /**
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    */
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Compute the dimension of a cell for an NxN layout with space S between
        // cells.  Take the collection view's width, subtract (N-1)*S points for
        // the spaces between the cells, and then divide by N to find the final
        // dimension for the cell's width and height.
        
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
    
    
}

/** Not needed ... maybe later if I switch to custom UserDefault Object
struct ImageInfo {
    let path: String
    //var tags: Array<String>
}

struct ImagesData {
    static var images: Array<ImageInfo> = []
}
*/
