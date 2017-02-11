//
//  AchievementStepLog+CoreDataClass.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 2/11/17.
//  Copyright © 2017 Zero Mu, LLC. All rights reserved.
//

import Foundation
import CoreData

public class AchievementStepLog: NSManagedObject {

    convenience init(datetime: NSDate, achievementStepId: Int, appSession: AppSession, tdPerformanceLog: [TDPerformanceLog]?, context: NSManagedObjectContext){
        
        if let ent = NSEntityDescription.entity(forEntityName: "AchievementStepLog", in: context) {
            self.init(entity: ent, insertInto: context)
            
            self.datetime = datetime
            self.achievementStepId = Int64(achievementStepId)
            self.appSession = appSession
            
            //optionals
            if let log = tdPerformanceLog {
                
                self.tdPerformanceLog = log
                
            }
            
            
        } else {
            fatalError("Unable to find Entity name! (AchievementStepLog)")
        }
        
    }
    
}
