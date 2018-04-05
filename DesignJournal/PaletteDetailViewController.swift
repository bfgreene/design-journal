//
//  PaletteDetailViewController.swift
//  DesignJournal
//
//  Created by Ben Greene on 3/22/18.
//  Copyright © 2018 bfgreene. All rights reserved.
//

import UIKit

class PaletteDetailViewController: UIViewController, UITableViewDataSource {
    
    
    
    @IBOutlet var swatchesTableView: UITableView!
    var palette = [UIColor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return palette.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = swatchesTableView.dequeueReusableCell(withIdentifier: "swatchDetailCell") as! swatchDetailCell
        cell.colorLabel.backgroundColor = palette[indexPath.row]
        
        return cell
    }


  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}

class swatchDetailCell: UITableViewCell {
    
    @IBOutlet var colorLabel: UILabel!
    
    
}
