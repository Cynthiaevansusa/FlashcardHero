//
//  TDPerformanceLog+CoreDataClass.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 11/15/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import CoreData


public class TDPerformanceLog: NSManagedObject {

    convenience init(datetime: NSDate, questionTypeId: Int, wasCorrect: Bool, quizletTD: QuizletTermDefinition, wrongAnswerTD: QuizletTermDefinition?, wrongAnswerFITB: String?, context: NSManagedObjectContext){
        
        if let ent = NSEntityDescription.entity(forEntityName: "TDPerformanceLog", in: context) {
            self.init(entity: ent, insertInto: context)
            

                
            self.datetime = datetime
            self.questionTypeId = Int64(questionTypeId)
            self.wasCorrect = wasCorrect
            self.quizletTD = quizletTD
            
            //optionals
            if let wrongAnswerTD = wrongAnswerTD {

                self.wrongAnswerTD = wrongAnswerTD
  
            }
            if let wrongAnswerFITB = wrongAnswerFITB {
                
                self.wrongAnswerFITB = wrongAnswerFITB
                
            }
            
        } else {
            fatalError("Unable to find Entity name! (QuizletTermDefinition)")
        }
        
    }
    
}
