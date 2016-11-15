//
//  GameDirectory.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 11/15/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
struct GameDirectory {
    
    static var gameTrueFalse = Game(id: 0, name: "True or False", description: "This is the True or False description", storyboardId: "GameTrueFalse", isAvailable: true)
    
    static var allGames = [gameTrueFalse]
    static var activeGames = [gameTrueFalse]
    
    
}

//A Game struct is an object that tracks a Game that may or may not be available to the player.  These are placed in the GameDirectory.
struct Game {
    let id: Int
    var name: String
    var description: String?
    var storyboardId: String
    var isAvailable: Bool
    
    init(id: Int, name: String, description: String? = nil, storyboardId: String, isAvailable: Bool) {
        self.id = id
        
        self.name = name
        if let description = description {
            self.description = description
        } else {
            self.description = nil
        }
        
        self.storyboardId = storyboardId
        
        self.isAvailable = isAvailable
    }
    
}
