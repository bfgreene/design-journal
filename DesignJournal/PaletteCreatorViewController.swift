//
//  PaletteCreatorViewController.swift
//  DesignJournal
//
//  Created by Ben Greene on 3/21/18.
//  Copyright © 2018 bfgreene. All rights reserved.
//

import UIKit

class PaletteCreatorViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var colorBarView: UIView!
    @IBOutlet var pixelLabel: UILabel!
    var change = false

    func handleTap(withSender gestureRecognizer: UITapGestureRecognizer) {
        print("in handleTap()")
        var point: CGPoint?
        if gestureRecognizer.state == UIGestureRecognizerState.recognized {
            point = gestureRecognizer.location(in: gestureRecognizer.view)
            print(point!)
        }
        
        let pixelColor = getPixelColorAtPoint(point: point!, sourceView: imageView)
        print(pixelColor)
        colorBarView.backgroundColor = pixelColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = UIImage(named: "dtla-pink")
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(withSender: )))
        
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
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
