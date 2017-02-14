//
//  GemView.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 2/13/17.
//  Copyright © 2017 Zero Mu, LLC. All rights reserved.
//

import UIKit

let π:CGFloat = CGFloat(M_PI)
func radians(_ degrees: CGFloat) -> CGFloat {
    return (degrees * π/180)
}

@IBDesignable class GemView: UIView {

    private var _topState: Int = 0
    private var _leftState: Int = 0
    private var _rightState: Int = 0
    private var _bottomState: Int = 0
    
    var topState: Int{
        get {
            return _topState
        }
        set (new) {
            if GemView.acceptableStates.contains(new) {
                _topState = new
            }
        }
    }
    
    var leftState: Int{
        get {
            return _leftState
        }
        set (new) {
            if GemView.acceptableStates.contains(new) {
                _leftState = new
            }
        }
    }
    
    var rightState: Int{
        get {
            return _rightState
        }
        set (new) {
            if GemView.acceptableStates.contains(new) {
                _rightState = new
            }
        }
    }
    
    var bottomState: Int{
        get {
            return _bottomState
        }
        set (new) {
            if GemView.acceptableStates.contains(new) {
                _bottomState = new
            }
        }
    }
    
    static let None = 0
    static let Low = 1
    static let Medium = 2
    static let High = 3
    static let Highest = 4
    
    static let acceptableStates = [None, Low, Medium, High, Highest]
    static let stateColors = [None: UIColor.gray.cgColor,
                              Low: UIColor.red.cgColor,
                              Medium: UIColor.yellow.cgColor,
                              High: UIColor.green.cgColor,
                              Highest: UIColor.purple.cgColor]
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let singleLength = rect.width/3
        context?.setLineWidth(1.0)
        context?.setStrokeColor(UIColor.black.cgColor)
        
        //create the squares for each section
        let top = CGRect(x: 0, y: 0, width: singleLength, height: singleLength)
        let left = CGRect(x: 0, y: 0, width: singleLength, height: singleLength)
        let right = CGRect(x: 0, y: 0, width: singleLength, height: singleLength)
        let bottom = CGRect(x: 0, y: 0, width: singleLength, height: singleLength)
        
        //move the context to the center
        context?.translateBy(x: rect.midX, y: rect.midY)
        
        //rotate each section to make a diamond
        context?.rotate(by: radians(-135))
        context?.addRect(top)
        context?.strokePath()
        context?.setFillColor(GemView.stateColors[topState]!)
        context?.fill(top)
        
        context?.rotate(by: radians(90))
        context?.addRect(right)
        context?.strokePath()
        context?.setFillColor(GemView.stateColors[rightState]!)
        context?.fill(right)
        
        context?.rotate(by: radians(90))
        context?.addRect(bottom)
        context?.strokePath()
        context?.setFillColor(GemView.stateColors[bottomState]!)
        context?.fill(bottom)
        
        context?.rotate(by: radians(90))
        context?.addRect(left)
        context?.strokePath()
        context?.setFillColor(GemView.stateColors[leftState]!)
        context?.fill(left)
        
    }

}
