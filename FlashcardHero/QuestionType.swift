//
//  QuestionType.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 11/15/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation

struct QuestionTypes {
    static let TrueFalse = QuestionType(id: 0,
                                        name: "TrueFalse",
                                        description: "A term and a possible correct answer definition are presented.  The player chooses whether the answer shown is the correct answer or not.")
    
    static let types = [TrueFalse.id : TrueFalse]
}




struct QuestionType {
    let id: Int
    let name: String
    let description: String
    
    init(id: Int, name: String, description: String) {
        self.id = id
        self.name = name
        self.description = description
    }
}
