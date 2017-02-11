//
//  Achievement.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 2/11/17.
//  Copyright © 2017 Zero Mu, LLC. All rights reserved.
//

import Foundation
import UIKit

///Holds all Achivements.  Used by AchievementHandler (in addition to GameCenter) to determine if Achievements have been accomplished.
struct AchievementDirectory {
    static let CorrectAnswer = Achievement(id: 0,
                                                    name: AchievementStepDirectory.CorrectAnswer.name,
                                                    description: AchievementStepDirectory.CorrectAnswer.description,
                                                    isGameCenter: false,
                                                    isRepeatable: true,
                                                    essenceBaseValue: 1,
                                                    icon: #imageLiteral(resourceName: "GemRed"),
                                                    steps: [AchievementStepDirectory.CorrectAnswer.name:1])
    
    static let CompleteMission = Achievement(id: 1,
                                                      name: AchievementStepDirectory.CompleteMission.name,
                                                      description: AchievementStepDirectory.CompleteMission.description,
                                                      isGameCenter: false,
                                                      isRepeatable: true,
                                                      essenceBaseValue: 10,
                                                      icon: #imageLiteral(resourceName: "GemRed"),
                                                      steps: [AchievementStepDirectory.CompleteMission.name:1])
    
    static let all = [CorrectAnswer.id:CorrectAnswer,
                      CompleteMission.id:CompleteMission]
    static let active = [CorrectAnswer.id:CorrectAnswer,
                         CompleteMission.id:CompleteMission]
    
}

/// A step towards satisfying an achievement.  AchievementSteps are placed in the AchievementStepLog and read by the AchievementHandler to determine if an Achievement has been satisfied.
struct AchievementStep {
    let id: Int
    let name: String
    let description: String
    let isPerformanceBased: Bool
    
    init(id: Int, name: String, description: String, isPerformanceBased: Bool) {
        self.id = id
        self.name = name
        self.description = description
        self.isPerformanceBased = isPerformanceBased
    }
}

///holds all valid Achievement Step objects
struct AchievementStepDirectory {
    static let CorrectAnswer = AchievementStep(id: 0,
                                               name: "CorrectAnswer",
                                               description: "Correctly answer a single question in any game.",
                                               isPerformanceBased: true)
    
    static let CompleteMission = AchievementStep(id: 1,
                                               name: "CompleteMission",
                                               description: "Complete any mission successfully.",
                                               isPerformanceBased: true)
    
    static let all = [CorrectAnswer.id:CorrectAnswer,
                      CompleteMission.id:CompleteMission]
}

///represents an Achievement the player can earn by accomplishing one or more AchievementSteps
struct Achievement {
    let id: Int
    let name: String
    let description: String
    let isGameCenter: Bool
    let isRepeatable: Bool
    let essenceBaseValue: Int
    let icon: UIImage
    let steps: [String:Int] //an array of AchievementStep names, along with the number of each step needed
    
    init(id: Int, name: String, description: String, isGameCenter: Bool, isRepeatable: Bool, essenceBaseValue: Int, icon: UIImage, steps: [String:Int] ) {
        self.id = id
        self.name = name
        self.description = description
        self.isGameCenter = isGameCenter
        self.isRepeatable = isRepeatable
        self.essenceBaseValue = essenceBaseValue
        self.icon = icon
        self.steps = steps
    }
}

//this should be an empty function that does nothing when called, to allow for achievements that don't have any action neccessary when iterated
func interateProgressPlaceholder ()->Void {
    return
}
