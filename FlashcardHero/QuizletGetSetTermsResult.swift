//
//  QuizletGetSetTermsResult.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 11/2/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation

struct QuizletGetSetTermsResult {
    //a set result contains an optional QuizletSetSearchResults result and an array of QuizletTermsResult
    
    var set : QuizletSetSearchResult?
    var terms : [QuizletGetTermResult]
    
    init(from terms: [QuizletGetTermResult], set: QuizletSetSearchResult? = nil) {
        self.terms = terms
        
        if let inputSet = set {
            self.set = inputSet
        }
    }
}
