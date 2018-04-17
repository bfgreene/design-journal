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

class PaletteCreatorViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var table: UITableView!
    
    var imageFromPhoto = UIImageView()
   // var change = false
    
    var colors: [UIColor] = []
    @IBOutlet var addRowButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let photo = imageFromPhoto.image {
            imageView.image = photo
        } else {
            //TODO: replace with general "No Image"
            imageView.image = UIImage(named: "dtla-pink") //backup image
        }
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        
        imageView.backgroundColor = UIColor.black
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(withSender: )))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        addRowButton.backgroundColor = UIColor.white
        
        saveButton.isEnabled = false
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
        
        
        if colors.count > 0 { saveButton.isEnabled = true }
        if colors.count > 5 {
            addRowButton.isEnabled = false
            addRowButton.backgroundColor = .lightGray
            addRowButton.setTitleColor(.gray, for: .normal)
        }
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

            if colors.count < 1 { saveButton.isEnabled = false }
            if colors.count < 6 {
                addRowButton.isEnabled = true
                addRowButton.setTitleColor(.black, for: .normal)
            }
        }
    }
    
    @IBAction func savePalette(_ sender: Any) {
        let colorsData = colors.map({ (color:UIColor) -> NSData in
            return NSKeyedArchiver.archivedData(withRootObject: color) as NSData
        })
        
        let defaults = UserDefaults.standard
        var storedPalettes = defaults.object(forKey: "palettes") as? [[NSData]] ?? [[NSData]]()
        
        storedPalettes.append(colorsData)
        defaults.set(storedPalettes, forKey: "palettes")

        goBackToTabBar(self)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func goBackToTabBar(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToTabBar", sender: self)
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
