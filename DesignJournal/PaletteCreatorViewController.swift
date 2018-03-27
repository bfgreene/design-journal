//
//  PaletteCreatorViewController.swift
//  DesignJournal
//
//  Created by Ben Greene on 3/21/18.
//  Copyright © 2018 bfgreene. All rights reserved.
//

import UIKit

class swatchCell: UITableViewCell  {
    
    @IBOutlet var colorLabel: UILabel!
    var color: UIColor!
    
    
}

class PaletteCreatorViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDataSource {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var colorBarView: UIView!
    @IBOutlet var table: UITableView!
    var palettePreview: UIView!
    var change = false
    
    var fakeColors: [UIColor] = [UIColor.blue, UIColor.magenta, UIColor.purple]
    
    var numRows = 1
    
    
    @IBOutlet var addRowButton: UIButton!
    
    func handleTap(withSender gestureRecognizer: UITapGestureRecognizer) {
        var point: CGPoint?
        if gestureRecognizer.state == UIGestureRecognizerState.recognized {
            point = gestureRecognizer.location(in: gestureRecognizer.view)
        }
        
        colorBarView.backgroundColor = getPixelColorAtPoint(point: point!, sourceView: imageView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = UIImage(named: "dtla-pink")
        
        imageView.backgroundColor = UIColor.black
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(withSender: )))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        
        palettePreview = UIView(frame: CGRect(x: 0, y: 20, width: 400, height: 30 ))
        setPalettePreview(colors: [UIColor.white,UIColor.lightGray, UIColor.darkGray, UIColor.black])
        view.addSubview(palettePreview)
        
    }

    @IBAction func addSwatchRow(_ sender: Any) {
        let indexPath: IndexPath = IndexPath(row: numRows, section: 0)
        numRows += 1
        
        table.insertRows(at: [indexPath], with: .automatic)
    }
    
    
    
    
    /**
        make sure to remove sublayers before calling again(if user adds/changes selections)
    */
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
    
    
    /**
     TableViewDataSource Methods
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "swatchCell")! as! swatchCell
        
        cell.color = colorBarView.backgroundColor
        cell.colorLabel.backgroundColor = cell.color
        
        
        cell.textLabel?.text = String("#towel")
        cell.textLabel?.textAlignment = NSTextAlignment(rawValue: 0)!
        
        let borderView: UIView = UIView()
        borderView.layer.borderColor = UIColor.white.cgColor
        borderView.layer.borderWidth = 1
        borderView.layer.backgroundColor = UIColor.clear.cgColor
        cell.selectedBackgroundView = borderView
        
        return cell
        
    }
    
    
    
    
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
