//
//  GameProtocols.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 12/2/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation

//These game protocols are applied to any given game.  Games will be accessed using these protocols, which pass success and failure criteria.

protocol GameObjectiveBase: class {
    var gameCallerDelegate: GameCaller? {get set}
    
    func finishGame(_ didPlayerSucceed: Bool)
}

protocol GameObjectiveMaxPoints: GameObjectiveBase {
    func playGameUntil(playerScoreIs maxPoints: Int, unlessPlayerScoreReaches minPoints: Int?, sender: GameCaller)
}

protocol GameObjectiveConsecutivePoints: GameObjectiveBase {
    func playGameUntil(playerScores consecutivePoints: Int, unlessPlayerScoreReaches minPoints: Int?, sender: GameCaller)
}

protocol GameObjectivePerfectGame: GameObjectiveBase {
    func playGameUntil(playerReaches maxPoints: Int, unlessPlayerMisses missedPoints: Int, sender: GameCaller)
}


//classes that call games to be played must conform to the following
protocol GameCaller: class {
    func gameFinished(_ wasObjectiveAchieved: Bool)
}
