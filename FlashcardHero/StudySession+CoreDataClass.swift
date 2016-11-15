//
//  StudySession+CoreDataClass.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 11/15/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import CoreData


public class StudySession: NSManagedObject {
    
    convenience init(start: NSDate, stop: NSDate?, gameId: Int, appSession: AppSession, context: NSManagedObjectContext){
        
        if let ent = NSEntityDescription.entity(forEntityName: "StudySession", in: context) {
            self.init(entity: ent, insertInto: context)
            
            self.start = start
            self.gameId = Int64(gameId)
            self.appSession = appSession
            
            //optionals
            if let stop = stop {
                
                self.stop = stop
                
            }
 
            
        } else {
            fatalError("Unable to find Entity name! (StudySession)")
        }
        
    }
}
