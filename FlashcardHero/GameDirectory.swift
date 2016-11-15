//
//  GameDirectory.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 11/15/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
struct GameDirectory {
    
    static var gameTrueFalse = Game(title: "True or False", subtitle: "This is the True or False Subtitle", storyboardId: "GameTrueFalse", isAvailable: true)
    
    static var games = [gameTrueFalse]
    
    
}

//A Game struct is an object that tracks a Game that may or may not be available to the player.  These are placed in the GameDirectory.
struct Game {
    var title: String
    var subtitle: String?
    var storyboardId: String
    var isAvailable: Bool
    
    init(title: String, subtitle: String? = nil, storyboardId: String, isAvailable: Bool) {
        self.title = title
        if let subtitle = subtitle {
            self.subtitle = subtitle
        } else {
            self.subtitle = nil
        }
        
        self.storyboardId = storyboardId
        
        self.isAvailable = isAvailable
    }
    
}
