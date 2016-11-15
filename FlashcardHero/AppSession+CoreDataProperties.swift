//
//  AppSession+CoreDataProperties.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 11/15/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import CoreData


extension AppSession {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppSession> {
        return NSFetchRequest<AppSession>(entityName: "AppSession");
    }

    @NSManaged public var start: NSDate?
    @NSManaged public var stop: NSDate?

}
