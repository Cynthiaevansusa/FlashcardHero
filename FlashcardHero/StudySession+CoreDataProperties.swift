//
//  StudySession+CoreDataProperties.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 11/15/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import CoreData


extension StudySession {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StudySession> {
        return NSFetchRequest<StudySession>(entityName: "StudySession");
    }

    @NSManaged public var start: NSDate
    @NSManaged public var stop: NSDate?
    @NSManaged public var gameId: Int64
    @NSManaged public var appSession: AppSession

}
