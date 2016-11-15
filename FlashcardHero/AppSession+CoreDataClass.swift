//
//  AppSession+CoreDataClass.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 11/15/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import CoreData


public class AppSession: NSManagedObject {

    convenience init(start: NSDate, stop: NSDate?, context: NSManagedObjectContext){
        
        if let ent = NSEntityDescription.entity(forEntityName: "AppSession", in: context) {
            self.init(entity: ent, insertInto: context)
            
            self.start = start
            
            //optionals
            if let stop = stop {
                
                self.stop = stop
                
            }
            
            
        } else {
            fatalError("Unable to find Entity name! (AppSession)")
        }
        
    }
}
