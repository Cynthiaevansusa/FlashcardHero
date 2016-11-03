//
//  QuizletTermDefinition+CoreDataProperties.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 11/3/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import CoreData


extension QuizletTermDefinition {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuizletTermDefinition> {
        return NSFetchRequest<QuizletTermDefinition>(entityName: "QuizletTermDefinition");
    }

    @NSManaged public var termId: Int64
    @NSManaged public var term: String?
    @NSManaged public var definition: String?
    @NSManaged public var rank: Int64
    @NSManaged public var imageHeight: Int64
    @NSManaged public var imageUrl: String?
    @NSManaged public var imageWidth: Int64
    @NSManaged public var imageData: NSData?
    @NSManaged public var quizletSet: QuizletSet?

}
