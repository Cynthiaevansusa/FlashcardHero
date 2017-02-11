//
//  EssenceIncomeLog+CoreDataClass.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 2/11/17.
//  Copyright © 2017 Zero Mu, LLC. All rights reserved.
//

import Foundation
import CoreData


public class EssenceIncomeLog: NSManagedObject {
    convenience init(datetime: NSDate, baseEssenceEarned: Int, valueModifierId: Int, achievementStepLog: AchievementStepLog, context: NSManagedObjectContext){
        
        if let ent = NSEntityDescription.entity(forEntityName: "EssenceIncomeLog", in: context) {
            self.init(entity: ent, insertInto: context)
            
            self.datetime = datetime
            
            //actual essence is based on the valueModifier
            let modifier = ValueModifierDirectory.all[valueModifierId]!
            var income = Float(baseEssenceEarned)
            income = income * modifier.multiplier
            income = income + Float(modifier.addend)
            income = round(income)
            
            self.actualEssenceEarned = Int64(income)
            self.valueModifierId = Int64(valueModifierId)
            self.achievementStepLog = achievementStepLog
            
            
        } else {
            fatalError("Unable to find Entity name! (EssenceIncomeLog)")
        }
        
    }
}
