//
//  QuizletSet+CoreDataProperties.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 11/1/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import CoreData


extension QuizletSet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuizletSet> {
        return NSFetchRequest<QuizletSet>(entityName: "QuizletSet");
    }

    @NSManaged public var accessType: Int64
    @NSManaged public var canEdit: Bool
    @NSManaged public var createdBy: String
    @NSManaged public var createdDate: NSDate
    @NSManaged public var creatorId: Int64
    @NSManaged public var editable: String
    @NSManaged public var hasAccess: Bool
    @NSManaged public var hasImages: Bool
    @NSManaged public var id: Int64
    @NSManaged public var langDefinitions: String
    @NSManaged public var langTerms: String
    @NSManaged public var modifiedDate: NSDate
    @NSManaged public var passwordEdit: Bool
    @NSManaged public var passwordUse: Bool
    @NSManaged public var publishedDate: NSDate
    @NSManaged public var setDescription: String?
    @NSManaged public var subjects: String?
    @NSManaged public var termCount: Int64
    @NSManaged public var title: String
    @NSManaged public var url: String
    @NSManaged public var visibility: String
    @NSManaged public var isActive: Bool

}
