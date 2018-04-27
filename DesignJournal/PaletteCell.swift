//
//  PaletteCell.swift
//  DesignJournal
//
//  Created by Ben Greene on 4/25/18.
//  Copyright © 2018 bfgreene. All rights reserved.
//

import UIKit

class PaletteCell: UITableViewCell {
    var colors: [UIColor]!
    var colorsHex: [String]!
    
    @IBOutlet var swatchCells: [UIView]!
}
