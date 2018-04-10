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
            hex += String(format: "%2x", rgb[1])
            hex += String(format: "%2x", rgb[2])
            return hex
        })
        return colorsHex
    }
    
    /*
     func convert(rgb r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> (c: CGFloat, m: CGFloat, y: CGFloat, k: CGFloat) {
     let r = r / 255
     let g = g / 255
     let b = b / 255
     
     let k = 1 - max(r, g, b)
     let c = (k == 1) ? 0 : (1 - r - k) / (1 - k)
     let m = (k == 1) ? 0 : (1 - g - k) / (1 - k)
     let y = (k == 1) ? 0 : (1 - b - k) / (1 - k)
     
     return (c, m, y, k)
     }
    */
    
}
