//
//  PaletteCreatorViewController.swift
//  DesignJournal
//
//  Created by Ben Greene on 3/21/18.
//  Copyright © 2018 bfgreene. All rights reserved.
//

import UIKit

class swatchCell: UITableViewCell  {
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var colorLabel: UILabel!
    var color: UIColor!
}

class PaletteCreatorViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDataSource {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var table: UITableView!
    
    var imageFromPhoto = UIImageView()
    
    var palettePreview: UIView!
    var change = false
    
    var colors: [UIColor] = []
    @IBOutlet var addRowButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let photo = imageFromPhoto.image {
            imageView.image = photo
        } else {
            imageView.image = UIImage(named: "dtla-pink") //backup image
        }
        
        imageView.backgroundColor = UIColor.black
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(withSender: )))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        
        let screenSize = UIScreen.main.bounds
        palettePreview = UIView(frame: CGRect(x: 0, y: 20, width: screenSize.width, height: 30 ))
        setPalettePreview(colors: [UIColor.white,UIColor.lightGray, UIColor.darkGray, UIColor.black])
        view.addSubview(palettePreview)
        
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        addRowButton.backgroundColor = UIColor.white
        
    }
    
    func handleTap(withSender gestureRecognizer: UITapGestureRecognizer) {
        var point: CGPoint?
        if gestureRecognizer.state == UIGestureRecognizerState.recognized {
            point = gestureRecognizer.location(in: gestureRecognizer.view)
        }
        
        addRowButton.backgroundColor = getPixelColorAtPoint(point: point!, sourceView: imageView)
    }

    @IBAction func addSwatchRow(_ sender: UIButton) {
        let indexPath: IndexPath = IndexPath(row: colors.count, section: 0)
        colors.append(sender.backgroundColor!)
        
        table.beginUpdates()
        table.insertRows(at: [indexPath], with: .automatic)
        table.endUpdates()
        table.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    
    
    
    // TODO: make sure to remove sublayers before calling again(if user adds/changes selections)
    func setPalettePreview(colors: [UIColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = palettePreview.bounds
        
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
        
        
        palettePreview.backgroundColor = UIColor.clear
        palettePreview.layer.addSublayer(gradientLayer)
        palettePreview.layer.masksToBounds = true
    }
    
    
    func getPixelColorAtPoint(point: CGPoint, sourceView: UIImageView) -> UIColor {
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        var color: UIColor? = nil
        
        if let context = context {
            context.translateBy(x: -point.x, y: -point.y)
            sourceView.layer.render(in: context)
            
            color = UIColor(red: CGFloat(pixel[0])/255.0,
                            green: CGFloat(pixel[1])/255.0,
                            blue: CGFloat(pixel[2])/255.0,
                            alpha: CGFloat(pixel[3])/255.0)
            pixel.deallocate(capacity: 4)
        }
        return color!
    }
    
    
    
    //   MARK: TableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "swatchCell")! as! swatchCell
        
        cell.color = colors[indexPath.row]
        cell.colorLabel.backgroundColor = cell.color
        
        let rgb = cell.color.getRGB()
        cell.descriptionLabel?.text = "RGB:  \(rgb[0]), \(rgb[1]), \(rgb[2])"
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            table.beginUpdates()
            colors.remove(at: indexPath.row)
            table.deleteRows(at: [indexPath], with: .left)
            table.endUpdates()
        }
    }
    
    //TODO: don't allow save if not at least one color in colors
    @IBAction func savePalette(_ sender: Any) {
        
        let colorsData = colors.map({ (color:UIColor) -> NSData in
            return NSKeyedArchiver.archivedData(withRootObject: color) as NSData
        })
        
        
        let defaults = UserDefaults.standard
        var storedPalettes = defaults.object(forKey: "palettes") as? [[NSData]] ?? [[NSData]]()
        
       
        storedPalettes.append(colorsData)
        defaults.set(storedPalettes, forKey: "palettes")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }


}
