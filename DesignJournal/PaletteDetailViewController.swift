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
        let cell = swatchesTableView.dequeueReusableCell(withIdentifier: "swatchDetailCell") as! swatchDetailCell
        
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
    
    

}

class swatchDetailCell: UITableViewCell {
    
    @IBOutlet var colorLabel: UILabel!
    @IBOutlet var hexLabel: UILabel!
    @IBOutlet var rgbLabels: [UILabel]!
}
