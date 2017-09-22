//
//  Spinner.swift
//  Laundry
//
//  Created by alexon on 8/18/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit


let pi = 3.14159265359
let dotEnteringDelay = 0.6



class SHActivityView: UIView {
    
    
    enum SpinnerSize : Int
    {
        case kSHSpinnerSizeTiny // suitable for frmae size (30, 30)
        case kSHSpinnerSizeSmall // suitable for frame size (50, 50)
        case kSHSpinnerSizeMedium // suitable for frame size (150, 150)
        case kSHSpinnerSizeLarge // suitable for frame size (185, 185)
        case kSHSpinnerSizeVeryLarge // suitable for frame size (220,220)
    }
    
    
    
    
    /**
     * radius of the spinner/rotator will be different in each Spinner Size
     * default = kAVSpinnerSizeTiny
     * if its kSHSpinnerSizeVeryLarge or kSHSpinnerSizeLarge, kSHSpinnerSizeMedium, can able to set two title, one title in center of spinner and another in below the spinner
     */
    var spinnerSize : SpinnerSize?
    
    
    
    
    
    
    /**
     * spinner color
     * defaule = UIColor.whiteColor()
     */
    var spinnerColor : UIColor?
    
    
    
    
    
    
    
    /**
     * disable the user interaction of entire application
     * default = false
     */
    var disableEntireUserInteraction : Bool?
        {
        
        didSet
        {
            if(disableEntireUserInteraction == true)
            {
                UIApplication.shared.beginIgnoringInteractionEvents()
            }
        }
    }
    
    
    
    
    
    
    
    /**
     * center title
     * default = nil
     * WARNING, it wil not work when spinnerSize = kSHSpinnerSizeSmall || kSHSpinnerSizeTiny
     */
    var centerTitle : String?
    
    
    
    
    
    
    
    
    /**
     * bottom title
     * default = nil
     * WARNING, it wil not work when spinnerSize = kSHSpinnerSizeSmall || kSHSpinnerSizeTiny
     */
    var bottomTitle : String?
    
    
    var centerTitleColor : UIColor?
    
    
    var bottomTitleColor : UIColor?
    
    
    
    
    
    
    
    /**
     * center title font
     * WARNING, it wil not work when spinnerSize = kSHSpinnerSizeSmall || kSHSpinnerSizeTiny
     */
    var centerTitleFont : UIFont?
    
    
    
    
    
    
    
    
    var bottomTitleFont : UIFont?
    
    
    
    var stopBottomTitleDotAnimation : Bool?
    
    
    
    
    
    
    /**
     * stop animation when showing and dismissing the spinner
     */
    var stopShowingAndDismissingAnimation : Bool?
    
    
    
    
    private var viewActivitySquare : UIView?
    private var viewNotRotate : UIView?
    private var isAnimating : Bool?
    
    private func DEGREES_TO_RADIANS(degrees : Double) -> CGFloat
    {
        return CGFloat(((pi*degrees) / 180))
    }
    
    func showAndStartAnimate()
    {
        if (isAnimating == true)
        {
            print("WARNING already animation started")
            return;
        }
        else
        {
            isAnimating = true
        }
        self.alpha = 0.0;
        if (self.backgroundColor == nil && spinnerSize != .kSHSpinnerSizeTiny && spinnerSize != .kSHSpinnerSizeSmall)
        {
            self.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        }
        else
        {
            if ( self.backgroundColor?.isEqual(UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)) == true || self.backgroundColor?.isEqual(UIColor.white) == true )
            {
                print("WARNING background color is white, so you cannot see the spinner")
            }
        }
        
        if(disableEntireUserInteraction == true)
        {
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
        viewNotRotate = self
        viewActivitySquare = UIView.init()
        var frameViewActivitySquare : CGRect?
        if (spinnerSize == .kSHSpinnerSizeTiny)
        {
            frameViewActivitySquare = CGRect(x: 0, y: 0, width: 30, height: 30)
            self.frame = frameViewActivitySquare!
        }
        else if (spinnerSize == .kSHSpinnerSizeSmall)
        {
            frameViewActivitySquare = CGRect(x: 0, y: 0, width: 50, height: 50)
            self.frame = frameViewActivitySquare!
        }
        else if (spinnerSize == .kSHSpinnerSizeMedium || spinnerSize == .kSHSpinnerSizeLarge || spinnerSize == .kSHSpinnerSizeVeryLarge)
        {
            var labelCenter : UILabel?
            var labelBottom : UILabel?
            if (spinnerSize == .kSHSpinnerSizeMedium)
            {
                frameViewActivitySquare = CGRect(x: 0, y: 0, width: 82, height: 82)
                viewNotRotate?.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
            }
            else if (spinnerSize == .kSHSpinnerSizeLarge)
            {
                frameViewActivitySquare = CGRect(x: 0, y: 0, width: 120, height: 120)
                viewNotRotate?.frame = CGRect(x: 0, y: 0, width: 185, height: 185)
            }
            else if (spinnerSize == .kSHSpinnerSizeVeryLarge)
            {
                frameViewActivitySquare = CGRect(x: 0, y: 0, width: 150, height: 150)
                viewNotRotate?.frame = CGRect(x: 0, y: 0, width: 220, height: 220)
            }
            if (centerTitle != nil)
            {
                labelCenter = UILabel(frame:
                    CGRect(x:(viewNotRotate?.frame.size.width)!/4, y: ((viewNotRotate?.frame.size.height)!/2)-15, width: (viewNotRotate?.frame.size.width)!-(2*((viewNotRotate?.frame.size.width)!/4)), height: 30))
                

                
                
                if (centerTitleFont != nil)
                {
                    labelCenter?.font = centerTitleFont
                }
                labelCenter?.text = centerTitle
                if (centerTitleColor != nil)
                {
                    labelCenter?.textColor = centerTitleColor
                }
                else
                {
                    labelCenter?.textColor = UIColor.white
                }
                labelCenter?.textAlignment = .center
                labelCenter?.backgroundColor = UIColor.clear
                labelCenter?.adjustsFontSizeToFitWidth = true
                viewNotRotate?.addSubview(labelCenter!)
            }
            
            if (bottomTitle != nil)
            {
                var widthLabelDot = 0.0
                if (stopBottomTitleDotAnimation == nil || stopBottomTitleDotAnimation == false)
                {
                    widthLabelDot = 20
                }
                labelBottom = UILabel.init()
                if (bottomTitleFont != nil)
                {
                    labelBottom?.font = bottomTitleFont
                }
                labelBottom?.backgroundColor = UIColor.clear
                labelBottom?.text = bottomTitle
                labelBottom?.adjustsFontSizeToFitWidth = true
                let sizeWithFont = bottomTitle!.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: UIFont.systemFontSize)])
                if (sizeWithFont.width < (viewNotRotate?.frame.size.width)!)
                {
                    let width = CGFloat((viewNotRotate?.frame.size.width)! - sizeWithFont.width)
                    labelBottom?.frame =   CGRect(x: (width/2)-((CGFloat(widthLabelDot))/2), y:(viewNotRotate?.frame.size.height)! - 35, width:  sizeWithFont.width, height: 30)
                    
                    
                    
                }
                else
                {
                    if (stopBottomTitleDotAnimation == nil || stopBottomTitleDotAnimation == false)
                    {
                        print("WARNING bottom title is too lengthy so Dot animation not possible");
                        stopBottomTitleDotAnimation = true
                    }
                    labelBottom?.frame =  CGRect(x: 0, y:(viewNotRotate?.frame.size.height)! - 35, width:  (viewNotRotate?.frame.size.width)!, height: 30)
                    
                    labelBottom?.textAlignment = .center
                }
                if (bottomTitleColor != nil)
                {
                    labelBottom?.textColor = bottomTitleColor
                }
                else
                {
                    labelBottom?.textColor = UIColor.white
                }
                viewNotRotate?.addSubview(labelBottom!)
                
                if(stopBottomTitleDotAnimation == nil || stopBottomTitleDotAnimation == false)
                {
                    let labelDot = UILabel(frame:
                        CGRect(x: labelBottom!.frame.origin.x + labelBottom!.frame.size.width + 1, y: labelBottom!.frame.origin.y, width: CGFloat(widthLabelDot), height: labelBottom!.frame.size.height))
                    
                   
                    
                    
                    
                    if (bottomTitleFont != nil)
                    {
                        labelDot.font = bottomTitleFont
                    }
                    labelDot.backgroundColor = UIColor.clear
                    labelDot.adjustsFontSizeToFitWidth = true
                    if(bottomTitleColor != nil)
                    {
                        labelDot.textColor = bottomTitleColor
                    }
                    else
                    {
                        labelDot.textColor = UIColor.white
                    }
                    viewNotRotate?.addSubview(labelDot)
                    self.perform(Selector(("firstDot:")), with: labelDot, afterDelay: dotEnteringDelay)
                    
                }
            }
        }
        viewActivitySquare?.frame = frameViewActivitySquare!
        self.addSubview(viewActivitySquare!)
        
        let lowerPath = UIBezierPath(arcCenter: (viewActivitySquare?.center)!, radius: (viewActivitySquare?.frame.size.width)!/2.2, startAngle: DEGREES_TO_RADIANS(degrees: -5), endAngle: DEGREES_TO_RADIANS(degrees: 200), clockwise: true)
        let lowerShape = self.createShapeLayer(path: lowerPath)
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.frame = CGRect(x: 0, y:0, width: (viewActivitySquare?.frame.size.width)!, height: (viewActivitySquare?.frame.size.height)!)
        
        
        
        
        var colorSpinner = spinnerColor
        
        if (colorSpinner == nil)
        {
            colorSpinner = UIColor.white
        }
        gradientLayer.colors = NSArray(objects: (colorSpinner?.cgColor)!,UIColor.white.withAlphaComponent(0.0).cgColor,UIColor.white.withAlphaComponent(0.0).cgColor,UIColor.clear.cgColor) as! [CGColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.8)
        gradientLayer.endPoint = CGPoint(x: 2.0, y: 5.0)
        gradientLayer.mask = lowerShape
        viewActivitySquare?.layer.addSublayer(gradientLayer)
        
        let upperPath = UIBezierPath(arcCenter: (viewActivitySquare?.center)!, radius: (viewActivitySquare?.frame.size.width)!/2.2, startAngle: DEGREES_TO_RADIANS(degrees: 200), endAngle: DEGREES_TO_RADIANS(degrees: 300), clockwise: true)
        let upperShape = self.createShapeLayer(path: upperPath)
        if (spinnerColor != nil)
        {
            upperShape.strokeColor = spinnerColor?.cgColor
        }
        else
        {
            upperShape.strokeColor = UIColor.white.cgColor
        }
        viewActivitySquare?.layer.addSublayer(upperShape)
        NotificationCenter.default.addObserver(self, selector: #selector(SHActivityView.rotationAnimation), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        self.rotationAnimation()
        viewActivitySquare?.center = CGPoint(x: (viewNotRotate?.frame.size.width)!/2, y: (viewNotRotate?.frame.size.height)!/2)
        
        
        
        
        
        
        UIView.animate(withDuration: (stopShowingAndDismissingAnimation == true) ? 0.0 : 0.5) { () -> Void in
            self.alpha = 1.0
        }
        
    }
    
    private func createShapeLayer(path : UIBezierPath) -> CAShapeLayer
    {
        let shape = CAShapeLayer.init()
        shape.path = path.cgPath
        if (spinnerSize == .kSHSpinnerSizeSmall)
        {
            shape.lineWidth = 4.0
        }
        else if (spinnerSize == .kSHSpinnerSizeMedium)
        {
            shape.lineWidth = 8.0
        }
        else if (spinnerSize == .kSHSpinnerSizeLarge)
        {
            shape.lineWidth = 10.0
        }
        else if (spinnerSize == .kSHSpinnerSizeVeryLarge)
        {
            shape.lineWidth = 12.0
        }
        shape.lineCap = kCALineCapRound
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor(white: 1.0, alpha: 1.0).cgColor
        return shape
    }
    
    
    @objc private func rotationAnimation()
    {
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        rotate.fromValue = NSNumber(value: 0.0)
        rotate.toValue = NSNumber(value: 6.2)
        rotate.repeatCount = Float(CGFloat.greatestFiniteMagnitude)
        rotate.duration = 1.5
        viewActivitySquare?.layer .add(rotate, forKey: "rotateRepeatedly")
        
    }
    
    @objc private func firstDot(label:UILabel)
    {
        label.text = "."
        self.perform(Selector(("secondDot:")), with: label, afterDelay: dotEnteringDelay)
    }
    
    @objc private func secondDot(label:UILabel)
    {
        label.text = ".."
        self.perform(Selector(("thirdDot:")), with: label, afterDelay: dotEnteringDelay)
    }
    
    @objc private func thirdDot(label:UILabel)
    {
        label.text = "..."
        self.perform(Selector(("removeAllDots:")), with: label, afterDelay : dotEnteringDelay)
    }
    
    @objc private func removeAllDots(label:UILabel)
    {
        label.text = ""
        self.perform(Selector(("firstDot:")), with: label, afterDelay: dotEnteringDelay)
    }
    
    func dismissAndStopAnimation()
    {
        UIView.animate(withDuration: (stopShowingAndDismissingAnimation == true) ? 0.0 : 0.5, animations: { () -> Void in
            self.alpha = 0.0
        }) { (finished) -> Void in
            if (finished == true)
            {
                self.isAnimating = false
                for view : UIView in self.subviews
                {
                    view.removeFromSuperview()
                }
                
                if (self.disableEntireUserInteraction == true)
                {
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
                
            }
        }
    }
    
}

