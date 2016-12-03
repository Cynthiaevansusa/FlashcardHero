//
//  GameLevel+CoreDataProperties.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 12/2/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import CoreData


extension GameLevel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameLevel> {
        return NSFetchRequest<GameLevel>(entityName: "GameLevel");
    }

    @NSManaged public var gameId: Int64
    @NSManaged public var level: Int64

}
