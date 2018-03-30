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
    var palettesFromDefaults = [[String]]()
    var numPalettes = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        defaults.set([], forKey: "palettes")
        
        palettesFromDefaults = (UserDefaults.standard.array(forKey: "palettes") as? [[String]])!
        numPalettes = palettesFromDefaults.count
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let updatedPalettes = UserDefaults.standard.array(forKey: "palettes") as? [[String]]
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
        
        let cell = palettesTableView.dequeueReusableCell(withIdentifier: "paletteCell")! as! paletteCell
        
        let colorString = palettesFromDefaults[indexPath.row][0]
        cell.textLabel?.text = colorString
    
        //r
        var start = colorString.index(colorString.startIndex, offsetBy: 0)
        var end = colorString.index(colorString.startIndex, offsetBy: 2)
        var range = start..<end
        let r =  colorString.substring(with: range)
        let intR = Int(r, radix:16)
        let floatR: CGFloat = CGFloat(Double(intR!) / 255.0)
        //g
        start = colorString.index(colorString.startIndex, offsetBy: 2)
        end = colorString.index(colorString.startIndex, offsetBy: 4)
        range = start..<end
        let g =  colorString.substring(with: range)
        let intG = Int(g, radix:16)
        let floatG: CGFloat = CGFloat(Double(intG!) / 255.0)
        //b
        start = colorString.index(colorString.startIndex, offsetBy: 4)
        end = colorString.index(colorString.startIndex, offsetBy: 6)
        range = start..<end
        let b =  colorString.substring(with: range)
        let intB = Int(b, radix:16)
        let floatB: CGFloat = CGFloat(Double(intB!) / 255.0)
        
        
        let bgColor = UIColor.init(red: floatR, green: floatG, blue: floatB, alpha: 1)
        cell.backgroundColor = bgColor
        
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
}
