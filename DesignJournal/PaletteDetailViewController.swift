//
//  PaletteDetailViewController.swift
//  DesignJournal
//
//  Created by Ben Greene on 3/22/18.
//  Copyright © 2018 bfgreene. All rights reserved.
//

import UIKit

class PaletteDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var swatchesTableView: UITableView!
    var palette = [UIColor]()
    var hexStrings = [String]()
    var rgbValues = [[Int]]()
    var paletteIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hexStrings = UIColor.toHexArray(colors: palette)
        rgbValues = palette.map({ (color:UIColor) -> [Int] in
            return color.getRGB()
        })
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //   MARK: UITableViewDataSource and Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return palette.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = swatchesTableView.dequeueReusableCell(withIdentifier: "swatchDetailCell") as! SwatchDetailCell
        
        cell.selectionStyle = .none
        cell.colorLabel.backgroundColor = palette[indexPath.row]
        cell.hexLabel.text = "#\(hexStrings[indexPath.row])".uppercased()
        cell.hexLabel.sizeToFit()
        for label in cell.rgbLabels {
            let value = " \(rgbValues[indexPath.row][label.tag])"
            label.text?.append(value)
            label.sizeToFit()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: "Delete this palette?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {_ in }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive){_ in
            self.deleteImage()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteImage() {
        var palettes = UserDefaults.standard.array(forKey: "palettes") as? [[NSData]]
        if let size = palettes?.count, size > paletteIndex {
            palettes!.remove(at: paletteIndex)
            UserDefaults.standard.set(palettes!, forKey: "palettes")
        } else {
            print("Error: could not delete palette")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
