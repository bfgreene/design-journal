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
        if (updatedPalettes?.count)! != numPalettes {
            palettesFromDefaults = updatedPalettes!
            palettesTableView.reloadData()
            numPalettes = palettesFromDefaults.count
        }
        
    }

    
    /**
    *   UITableViewDataSource methods
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return palettesFromDefaults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = palettesTableView.dequeueReusableCell(withIdentifier: "paletteCell")! as! paletteCell
        
        
        let palette = palettesFromDefaults[indexPath.row].map({(color: NSData) -> UIColor in
            return (NSKeyedUnarchiver.unarchiveObject(with: color as Data) as? UIColor)!
        })
        
        cell.backgroundColor = palette[0]
        
        /*
        if cell.paletteView != nil {
            cell.paletteView.removeFromSuperview()
        }
        
        cell.paletteView = UIView(frame: CGRect(origin: cell.frame.origin, size: cell.frame.size))
        let gradientLayer = setPaletteView(cell: cell, colors: palette)
        
        cell.paletteView.backgroundColor = UIColor.clear
        cell.paletteView.layer.addSublayer(gradientLayer)
        cell.paletteView.layer.masksToBounds = true
        
        
        cell.contentView.addSubview(cell.paletteView)
        */
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            palettesTableView.beginUpdates()
            
            let cell = palettesTableView.cellForRow(at: indexPath)
            let subviews = cell?.contentView.subviews
            for view in subviews! {
                view.removeFromSuperview()
            }
            
            //remove from userdefaults
            let defaults = UserDefaults.standard
            var palettes = defaults.array(forKey: "palettes")
            palettes?.remove(at: indexPath.row)
            defaults.set(palettes, forKey: "palettes")
            
            palettesFromDefaults.remove(at: indexPath.row)
            palettesTableView.deleteRows(at: [indexPath], with: .left)
            numPalettes -= 1
            
            palettesTableView.endUpdates()
        }
    }

    
    
    
    /**
     TODO: make sure to remove sublayers before calling again(if user adds/changes selections)
     */
    func setPaletteView(cell: paletteCell, colors: [UIColor]) -> CAGradientLayer{
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
        
        return gradientLayer
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
