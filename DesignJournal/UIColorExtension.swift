//
//  UIColorExtension.swift
//  DesignJournal
//
//  Created by Ben Greene on 4/8/18.
//  Copyright © 2018 bfgreene. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    func getRGB() -> [Int] {
        var red:CGFloat = 0.0, green:CGFloat = 0.0, blue:CGFloat = 0.0, alpha:CGFloat = 0.0
        var rgb = [0,0,0]
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            rgb[0] = Int(red * 255)
            rgb[1] = Int(green * 255)
            rgb[2] = Int(blue * 255)
        }
        
        return rgb
    }
    
    static func toHexArray(colors: [UIColor]) -> [String] {
        let colorsRGB = colors.map({ (color:UIColor) -> [Int] in
            return color.getRGB()
        })
        let colorsHex = colorsRGB.map({ (rgb: [Int]) -> String in
            var hex = String(format: "%2x", rgb[0])
           // if rgb[0] < 16 { hex += "0" }
            hex += String(format: "%2x", rgb[1])
           // if rgb[1] < 16 { hex += "0" }
            hex += String(format: "%2x", rgb[2])
           // if rgb[2] < 16 { hex += "0" }
            return hex.replacingOccurrences(of: " ", with: "0")
        })
        return colorsHex
    }
    
}
