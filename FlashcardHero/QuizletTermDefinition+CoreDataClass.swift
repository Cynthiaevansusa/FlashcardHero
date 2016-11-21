//
//  QuizletTermDefinition+CoreDataClass.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 11/3/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import CoreData


public class QuizletTermDefinition: QuizletSet {

    //TODO: have this object load the image from url when imageUrl is set or changed
    
    convenience init(withQuizletTermResult: QuizletGetTermResult, relatedSet: QuizletSet, context: NSManagedObjectContext){
        
        if let ent = NSEntityDescription.entity(forEntityName: "QuizletTermDefinition", in: context) {
            self.init(entity: ent, insertInto: context)
            
            //using the FlickrPhotoResult, populate this object
            if  let termId = withQuizletTermResult.id,
                let term = withQuizletTermResult.term,
                let definition = withQuizletTermResult.definition,
                let rank = withQuizletTermResult.rank {
                
                self.termId = Int64(termId)
                self.term = term
                self.definition = definition
                self.rank = Int64(rank)
                
                //image is optional or blank
//                if let image = withQuizletTermResult.image {
//                    
//                    //TODO: add validation
//                    //TODO: Don't hard code this
//                    self.imageHeight = image["height"] as! Int64
//                    self.imageUrl = image["url"] as? String
//                    self.imageWidth = image["width"] as! Int64
//                }

                //add the related set
                self.quizletSet = relatedSet
                
            } else {
                //TODO: throw an error because everything wasn't as expected
            }
        } else {
            fatalError("Unable to find Entity name! (QuizletTermDefinition)")
        }
        
    }
}
