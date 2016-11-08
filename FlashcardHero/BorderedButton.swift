//
//  BorderedButton.swift
//  OnTheMap
//
//  Derrived from work Created by Jarrod Parkes on 2/11/15.
//  Copyright (c) 2015 Jarrod Parkes. All rights reserved.
//
//  Further devlopment by Jacob Foster Davis in August - September 2016

import UIKit

// MARK: - BorderedButton: Button

class BorderedButton: UIButton {

    // MARK: Properties
    
    // constants for styling and configuration
    let darkerBlue = UIColor(red: 0.0, green: 0.298, blue: 0.686, alpha:1.0)
    let lighterBlue = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
    let titleLabelFontSize: CGFloat = 17.0
    let borderedButtonHeight: CGFloat = 44.0
    let borderedButtonCornerRadius: CGFloat = 4.0
    let phoneBorderedButtonExtraPadding: CGFloat = 14.0
    
    let randoColorOptions = [UIColor(red: 51.0/255.0, green: 204.0/255.0, blue: 255.0/255.0, alpha:1.0),
                             UIColor(red: 51.0/255.0, green: 102.0/255.0, blue: 255.0/255.0, alpha:1.0),
                             UIColor(red: 102.0/255.0, green: 51.0/255.0, blue: 255.0/255.0, alpha:1.0),
                             UIColor(red: 204.0/255.0, green: 51.0/255.0, blue: 255.0/255.0, alpha:1.0),
                             UIColor(red: 51.0/255.0, green: 255.0/255.0, blue: 204.0/255.0, alpha:1.0),
                             UIColor(red: 0.0/255.0, green: 184.0/255.0, blue: 245.0/255.0, alpha:1.0),
                             UIColor(red: 0.0/255.0, green: 138.0/255.0, blue: 184.0/255.0, alpha:1.0),
                             UIColor(red: 255.0/255.0, green: 51.0/255.0, blue: 204.0/255.0, alpha:1.0),
                             UIColor(red: 51.0/255.0, green: 255.0/255.0, blue: 102.0/255.0, alpha:1.0),
                             UIColor(red: 184.0/255.0, green: 46.0/255.0, blue: 0.0/255.0, alpha:1.0),
                             UIColor(red: 245.0/255.0, green: 61.0/255.0, blue: 0.0/255.0, alpha:1.0),
                             UIColor(red: 255.0/255.0, green: 51.0/255.0, blue: 102.0/255.0, alpha:1.0),
                             UIColor(red: 102.0/255.0, green: 255.0/255.0, blue: 51.0/255.0, alpha:1.0),
                             UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 51.0/255.0, alpha:1.0),
                             UIColor(red: 255.0/255.0, green: 204.0/255.0, blue: 51.0/255.0, alpha:1.0),
                             UIColor(red: 255.0/255.0, green: 102.0/255.0, blue: 51.0/255.0, alpha:1.0)]
    
    var backingColor: UIColor? = nil
    var highlightedBackingColor: UIColor? = nil
    
    // MARK: Initialization
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        themeBorderedButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        themeBorderedButton()
    }
    
    fileprivate func themeBorderedButton() {
        layer.masksToBounds = true
        layer.cornerRadius = borderedButtonCornerRadius
        highlightedBackingColor = getRandoColor()
        backingColor = getRandoColor()
        backgroundColor = getRandoColor()
        setTitleColor(UIColor.white, for: UIControlState())
        titleLabel?.font = UIFont.systemFont(ofSize: titleLabelFontSize)
    }
    
    // MARK: Setters
    
    fileprivate func setBackingColor(_ newBackingColor: UIColor) {
        if let _ = backingColor {
            backingColor = getRandoColor()
            backgroundColor = getRandoColor()
        }
    }
    
    fileprivate func setHighlightedBackingColor(_ newHighlightedBackingColor: UIColor) {
        highlightedBackingColor = getRandoColor()
        backingColor = getRandoColor()
    }
    
    // MARK: Tracking
    
    override func beginTracking(_ touch: UITouch, with withEvent: UIEvent?) -> Bool {
        backgroundColor = getRandoColor()
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        backgroundColor = getRandoColor()
    }
    
    override func cancelTracking(with event: UIEvent?) {
        backgroundColor = getRandoColor()
    }
    
    // MARK: Layout
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let extraButtonPadding : CGFloat = phoneBorderedButtonExtraPadding
        var sizeThatFits = CGSize.zero
        sizeThatFits.width = super.sizeThatFits(size).width + extraButtonPadding
        sizeThatFits.height = borderedButtonHeight
        return sizeThatFits
    }
    
    //adapted from http://stackoverflow.com/questions/24003191/pick-a-random-element-from-an-array
    func getRandoColor() -> UIColor {
        let randomIndex = Int(arc4random_uniform(UInt32(self.randoColorOptions.count)))
        return randoColorOptions[randomIndex]
    }
}
