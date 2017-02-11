//
//  AchievementStepLog+CoreDataProperties.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 2/11/17.
//  Copyright © 2017 Zero Mu, LLC. All rights reserved.
//

import Foundation
import CoreData


extension AchievementStepLog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AchievementStepLog> {
        return NSFetchRequest<AchievementStepLog>(entityName: "AchievementStepLog");
    }

    @NSManaged public var datetime: NSDate
    @NSManaged public var achievementStepId: Int64
    @NSManaged public var appSession: AppSession
    @NSManaged public var tdPerformanceLog: [TDPerformanceLog]?
    @NSManaged public var essenceIncomeLog: [EssenceIncomeLog]?

}
