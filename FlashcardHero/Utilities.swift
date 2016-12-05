//
//  Utilities.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 10/27/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
// test

import Foundation

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
/*******************///MARK: Looping over struct and class properties
//http://stackoverflow.com/questions/27292255/how-to-loop-over-struct-properties-in-swift
/******************************************************/

//protocol PropertyLoopable
//{
//    func allProperties() throws -> [String: Any]
//}
//
//extension PropertyLoopable
//{
//    func allProperties() throws -> [String: Any] {
//        
//        var result: [String: Any] = [:]
//        
//        let mirror = Mirror(reflecting: self)
//        
////        guard let style = mirror.displayStyle, (style == .Struct || style == .Class) else {
////            //throw some error
////            throw NSError(domain: "hris.to", code: 777, userInfo: nil)
////        }
//        
//        for (labelMaybe, valueMaybe) in mirror.children {
//            guard let label = labelMaybe else {
//                continue
//            }
//            
//            result[label] = valueMaybe
//        }
//        
//        return result
//    }
//}

