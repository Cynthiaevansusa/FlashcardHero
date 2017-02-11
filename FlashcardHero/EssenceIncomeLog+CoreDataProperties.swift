//
//  EssenceIncomeLog+CoreDataProperties.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 2/11/17.
//  Copyright © 2017 Zero Mu, LLC. All rights reserved.
//

import Foundation
import CoreData


extension EssenceIncomeLog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EssenceIncomeLog> {
        return NSFetchRequest<EssenceIncomeLog>(entityName: "EssenceIncomeLog");
    }

    @NSManaged public var datetime: NSDate
    @NSManaged public var actualEssenceEarned: Int64
    @NSManaged public var valueModifierId: Int64
    @NSManaged public var achievementStepLog: AchievementStepLog

}
