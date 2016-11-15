//
//  TDPerformanceLog+CoreDataProperties.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 11/15/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import CoreData


extension TDPerformanceLog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TDPerformanceLog> {
        return NSFetchRequest<TDPerformanceLog>(entityName: "TDPerformanceLog");
    }

    @NSManaged public var datetime: NSDate
    @NSManaged public var questionTypeId: Int64
    @NSManaged public var wasCorrect: Bool
    @NSManaged public var wrongAnswerFITB: String?
    @NSManaged public var wrongAnswerTD: QuizletTermDefinition?
    @NSManaged public var quizletTD: QuizletTermDefinition

}
