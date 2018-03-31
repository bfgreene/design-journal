//
//  PalettesViewController.swift
//  DesignJournal
//
//  Created by Ben Greene on 3/29/18.
//  Copyright © 2018 bfgreene. All rights reserved.
//

import UIKit

class PalettesViewController: UIViewController, UITableViewDataSource {
    
    

    @IBOutlet var palettesTableView: UITableView!
    var palettesFromDefaults = [[NSData]]()
    var numPalettes = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        defaults.set([], forKey: "palettes")
        
        palettesFromDefaults = (UserDefaults.standard.array(forKey: "palettes") as? [[NSData]])!
        numPalettes = palettesFromDefaults.count
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let updatedPalettes = UserDefaults.standard.array(forKey: "palettes") as? [[NSData]]
        if (updatedPalettes?.count)! > numPalettes {
            palettesFromDefaults = updatedPalettes!
            palettesTableView.reloadData()
        }
        
    }

    
    //UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return palettesFromDefaults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        var cell = palettesTableView.dequeueReusableCell(withIdentifier: "paletteCell")! as! paletteCell
        
        let palette = palettesFromDefaults[indexPath.row].map({(color: NSData) -> UIColor in
            return (NSKeyedUnarchiver.unarchiveObject(with: color as Data) as? UIColor)!
        })
        
       // let c1 = palette[0]
       // cell.backgroundColor = c1
        cell.paletteView = UIView(frame: CGRect(origin: cell.frame.origin, size: cell.frame.size))
        cell.paletteView.contentMode = UIViewContentMode.scaleAspectFit
        cell = setPaletteView(cell: cell, colors: palette)
        cell.backgroundColor = UIColor.lightGray
        cell.addSubview(cell.paletteView)
        return cell
    }
    
    
    /**
     TODO: make sure to remove sublayers before calling again(if user adds/changes selections)
     */
    func setPaletteView(cell: paletteCell, colors: [UIColor]) -> paletteCell{
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = cell.paletteView.bounds
        
        var colorArray: [CGColor] = []
        var locationArray: [NSNumber] = []
        for(index, color) in colors.enumerated() {
            colorArray.append(color.cgColor)
            colorArray.append(color.cgColor)
            locationArray.append(NSNumber(value: (1.0 / Double(colors.count)) * Double(index)))
            locationArray.append(NSNumber(value: (1.0 / Double(colors.count)) * Double(index + 1)))
        }
        
        gradientLayer.colors = colorArray
        gradientLayer.locations = locationArray
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        
        cell.paletteView.backgroundColor = UIColor.clear
        cell.paletteView.layer.addSublayer(gradientLayer)
        
        cell.paletteView.layer.masksToBounds = true
        
        return cell
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


class paletteCell: UITableViewCell {
    var colors: [UIColor]!
    var colorsHex: [String]!
    var paletteView: UIView!
}
