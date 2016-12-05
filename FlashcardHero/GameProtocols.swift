//
//  GameProtocols.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 12/2/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation

//These game protocols are applied to any given game.  Games will be accessed using these protocols, which pass success and failure criteria.

struct GameVariantProtocols {
    static let MaxPoints = "MaxPoints"
    static let PerfectGame = "PerfectGame"
    
    static let protocols : Set<String> = [GameVariantProtocols.MaxPoints, GameVariantProtocols.PerfectGame]
    
    //mirror so that can iterate over this list
    //adapted from http://stackoverflow.com/questions/37569098/iterate-over-struct-attributes-in-swift
//    var customMirror : Mirror {
//        get {
//            return Mirror(self, children: ["MaxPoints" : GameProtocols.MaxPoints, "PerfectGame" : GameProtocols.PerfectGame])
//        }
//    }
}

protocol GameVariantBase: class {
    var gameCallerDelegate: GameCaller? {get set}
    
    func finishGame(_ didPlayerSucceed: Bool)
}

protocol GameVariantMaxPoints: GameVariantBase {
    func playGameUntil(playerScoreIs maxPoints: Int, unlessPlayerScoreReaches minPoints: Int?, sender: GameCaller)
}

protocol GameVariantConsecutivePoints: GameVariantBase {
    func playGameUntil(playerScores consecutivePoints: Int, unlessPlayerScoreReaches minPoints: Int?, sender: GameCaller)
}

protocol GameVariantPerfectGame: GameVariantBase {
    func playGameUntil(playerReaches maxPoints: Int, unlessPlayerMisses missedPoints: Int, sender: GameCaller)
}


//classes that call games to be played must conform to the following
protocol GameCaller: class {
    func gameFinished(_ wasObjectiveAchieved: Bool, forGame sender: Game)
}
