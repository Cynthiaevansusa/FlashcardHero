//
//  OverviewStatistic.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 11/16/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation

struct OverviewStatistic {
    
    var order: Int
    var description: String
    var number: String
    
    init(order: Int, description: String, number: String) {
        self.order = order
        self.description = description
        self.number = number
    }
    
}
