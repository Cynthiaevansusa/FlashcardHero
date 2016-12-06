//
//  GameDirectory.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 11/15/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import UIKit
struct GameDirectory {
    
    static let GameTrueFalse = Game(id: 0, name: "True or False", description: "Decide if the given text and image correspond to the given term.", iconImage: #imageLiteral(resourceName: "TrueFalseGameIcon"), storyboardId: "GameTrueFalse", isAvailable: true)
    
    static let allGames = [GameTrueFalse.id : GameTrueFalse]
    static let activeGames = [GameTrueFalse]
    
    static let activeGameVariants = [GameVariant(game: GameTrueFalse, gameProtocol: GameVariantProtocols.MaxPoints, description: "Points Goal"),
                                     GameVariant(game: GameTrueFalse, gameProtocol: GameVariantProtocols.PerfectGame, description: "Perfect Score")]
    
    
}

struct GameVariant {
    let game: Game
    let gameProtocol: String
    let description: String
    
    init(game: Game, gameProtocol: String, description: String) {
        guard GameVariantProtocols.protocols.contains(gameProtocol) else {
            fatalError("couldn't set a GameVariant")
        }
        
        self.game = game
        self.gameProtocol = gameProtocol
        self.description = description
        
    }
}

//A Game struct is an object that tracks a Game that may or may not be available to the player.  These are placed in the GameDirectory.
struct Game {
    let id: Int
    let name: String
    let description: String?
    let storyboardId: String
    let isAvailable: Bool
    var icon: UIImage?
    
    init(id: Int, name: String, description: String? = nil, iconImage: UIImage? = nil, storyboardId: String, isAvailable: Bool) {
        self.id = id
        
        self.name = name
        if let description = description {
            self.description = description
        } else {
            self.description = nil
        }
        
        if let image = iconImage {
            self.icon = image
        } else {
            self.icon = nil
        }
        
        self.storyboardId = storyboardId
        
        self.isAvailable = isAvailable
    }
    
}

