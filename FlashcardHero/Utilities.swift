//
//  Utilities.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 10/27/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
// test

import Foundation
import UIKit

/******************************************************/
/******************* Shuffle Mutable Collections **************/
//From http://stackoverflow.com/questions/24026510/how-do-i-shuffle-an-array-in-swift
/******************************************************/
//MARK: - Shuffle Mutable Collections

extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (unshuffledCount, firstUnshuffled) in zip(stride(from: c, to: 1, by: -1), indices) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}


/******************************************************/
/******************* Removing Object From Array by Value **************/
//http://stackoverflow.com/questions/24938948/array-extension-to-remove-object-by-value
/******************************************************/
//MARK: - Removing Object From Array by Value

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
            print("removeObject just removed an object")
        } else {
            print("Couldn't remove the object")
        }
    }
    
    func getIndex(of object: Element) -> Array.Index?{
        if let index = index(of: object) {
            return index
        } else {
            return nil
        }
    }
}

/******************************************************/
/*************///MARK: - Conversions to base64 and back
/******************************************************/
extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}

/******************************************************/
/*******************///MARK: Getting strings of timer intervals
//adapted from http://stackoverflow.com/questions/28872450/conversion-from-nstimeinterval-to-hour-minutes-seconds-milliseconds-in-swift
/******************************************************/

extension String {
    /**
     Replaces all occurances from string with replacement
     */
    public func replace(_ string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
}

extension DateInterval {
    
    /**
     returns a string based on given format.  Default is "hh:mm:ss:sss"
     
     - Parameters:
        - hh: hours
        - mm: minutes
        - MM: minutes, including sum of all hours.  If used, assumes aren't using hh or MM when summing
        - ss: whole seconds
        - sss: miliseconds
    
     - Returns: String
     */
    func timeIntervalAsString(format : String = "hh:mm:ss:sss") -> String {
        let ms      = Int((self.duration.truncatingRemainder(dividingBy: 1)) * 1000)
        let asInt   = NSInteger(self.duration)
        let s = asInt % 60
        let m = (asInt / 60) % 60
        let h = (asInt / 3600)
        let MM = h * 60 + m
        
        var value = format
        value = value.replace("hh",  replacement: String(format: "%0.2d", h))
        value = value.replace("MM",  replacement: String(format: "%0.2d", MM))
        value = value.replace("mm",  replacement: String(format: "%0.2d", m))
        value = value.replace("sss", replacement: String(format: "%0.3d", ms))
        value = value.replace("ss",  replacement: String(format: "%0.2d", s))
        return value
    }
    
}

/******************************************************/
/*******************///MARK: UIView Extensions
/******************************************************/

//adpated from https://www.andrewcbancroft.com/2014/07/27/fade-in-out-animations-as-class-extensions-with-swift/
extension UIView {
    func fadeIn() {
        // Move our fade out code from earlier
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0 // Instead of a specific instance of, say, birdTypeLabel, we simply set [thisInstance] (ie, self)'s alpha
        }, completion: nil)
    }

    func fadeOut() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
}
