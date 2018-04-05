//
//  PalettesViewController.swift
//  DesignJournal
//
//  Created by Ben Greene on 3/29/18.
//  Copyright © 2018 bfgreene. All rights reserved.
//

import UIKit

class PalettesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    

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
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        //should I do this everytime cell is set or just once somewhere?
        let palette = palettesFromDefaults[indexPath.row].map({(color: NSData) -> UIColor in
            return (NSKeyedUnarchiver.unarchiveObject(with: color as Data) as? UIColor)!
        })
        
        for swatch in cell.swatchCells {
            if swatch.tag < palette.count {
                swatch.backgroundColor = palette[swatch.tag]
            } else {
                swatch.backgroundColor = UIColor.white
            }
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            palettesTableView.beginUpdates()
            
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
    
    //UITableView Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "segueToPaletteDetail", sender: self.palettesTableView.cellForRow(at: indexPath))
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToPaletteDetail" {
            let paletteDetailVC = segue.destination as! PaletteDetailViewController
            let cell = sender as! paletteCell
            let colors = cell.swatchCells[0].backgroundColor
            paletteDetailVC.palette = [colors!]
        }
    }

}


class paletteCell: UITableViewCell {
    var colors: [UIColor]!
    var colorsHex: [String]!
    
    @IBOutlet var swatchCells: [UIView]!
}
