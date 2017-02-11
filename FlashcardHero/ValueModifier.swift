//
//  ValueModifier.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 2/11/17.
//  Copyright © 2017 Zero Mu, LLC. All rights reserved.
//

import Foundation


/// A modifier used to calculate the essence a player has.  They can earn essence and that value is modified by this object.
struct ValueModifier {
    let id: Int
    let name: String
    let description: String
    let multiplier: Float
    let addend: Int
    
    init(id: Int, name: String, description: String, multiplier: Float, addend: Int) {
        self.id = id
        self.name = name
        self.description = description
        self.multiplier = multiplier
        self.addend = addend
    }
}

///holds all valid Achievement Step objects
struct ValueModifierDirectory {
    static let None = ValueModifier(id: 0,
                                      name: "None",
                                      description: "No modification",
                                      multiplier: 1.0,
                                      addend: 0)
    
    static let Double = ValueModifier(id: 1,
                                               name: "Double",
                                               description: "Doubles the value.",
                                               multiplier: 2.0,
                                               addend: 0)
    
    static let all = [None.id: None,
        Double.id:Double]
}
