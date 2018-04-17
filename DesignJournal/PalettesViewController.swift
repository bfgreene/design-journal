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
    var palettesFromDefaults = [[UIColor]]()
    var numPalettes = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // let defaults = UserDefaults.standard
       // defaults.set([], forKey: "palettes")
        
        palettesFromDefaults = updatePalettesData()
        numPalettes = palettesFromDefaults.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let updatedPalettes = UserDefaults.standard.array(forKey: "palettes") as? [[NSData]] ?? [[NSData]]()
        if updatedPalettes.count != numPalettes {
            palettesFromDefaults = updatePalettesData()
            palettesTableView.reloadData()
            numPalettes = palettesFromDefaults.count
        }
        
        //crashing because called before reloadData() finishes
        // palettesTableView.scrollToRow(at: IndexPath(row: (palettesFromDefaults.count - 1), section: 0), at: .bottom, animated: true)
    
    }

    
    
    //   MARK: UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return palettesFromDefaults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = palettesTableView.dequeueReusableCell(withIdentifier: "paletteCell")! as! paletteCell
        cell.selectionStyle = .none

        let palette = palettesFromDefaults[indexPath.row]
        
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
    
    //   MARK: UITableView Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "segueToPaletteDetail", sender: self.palettesTableView.cellForRow(at: indexPath))
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    

    
    func updatePalettesData() -> [[UIColor]] {
        let palettesAsData = UserDefaults.standard.array(forKey: "palettes") as? [[NSData]]! ?? [[NSData]]()
        var palettesAsColors = [[UIColor]]()
        if palettesAsData != nil {
            for index in palettesAsData!.indices {
                let unarchivedPalette = palettesAsData![index].map({(color: NSData) -> UIColor in
                    return (NSKeyedUnarchiver.unarchiveObject(with: color as Data) as? UIColor)!
                })
                palettesAsColors.append(unarchivedPalette)
            }
        }
        return palettesAsColors
    }
    
    
    @IBAction func dismissInfoScreen(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToPaletteDetail",
        let indexPath = self.palettesTableView.indexPathForSelectedRow {
            let paletteDetailVC = segue.destination as! PaletteDetailViewController
            paletteDetailVC.palette = palettesFromDefaults[indexPath.row]
            paletteDetailVC.paletteIndex = indexPath.row
        }
    }

}

class paletteCell: UITableViewCell {
    var colors: [UIColor]!
    var colorsHex: [String]!
    
    @IBOutlet var swatchCells: [UIView]!
    
    
}
