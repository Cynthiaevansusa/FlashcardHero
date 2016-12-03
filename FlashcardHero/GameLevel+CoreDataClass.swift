//
//  GameLevel+CoreDataClass.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 12/2/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import CoreData


public class GameLevel: NSManagedObject {
    convenience init(gameId: Int, level: Int, context: NSManagedObjectContext){
        
        if let ent = NSEntityDescription.entity(forEntityName: "GameLevel", in: context) {
            self.init(entity: ent, insertInto: context)
            
            
            self.gameId = Int64(gameId)
            
            self.level = Int64(level)
            
            
        } else {
            fatalError("Unable to find Entity name! (GameLevel)")
        }
        
    }
}
