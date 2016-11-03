//
//  QuizletSet+CoreDataClass.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 11/1/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import CoreData


public class QuizletSet: NSManagedObject {

    
    convenience init(withQuizletSetSearchResult: QuizletSetSearchResult, context: NSManagedObjectContext){
        
        if let ent = NSEntityDescription.entity(forEntityName: "QuizletSet", in: context) {
            self.init(entity: ent, insertInto: context)
            
            //using the FlickrPhotoResult, populate this object
            if  let accessType = withQuizletSetSearchResult.access_type,
                let canEdit = withQuizletSetSearchResult.can_edit,
                let createdBy = withQuizletSetSearchResult.created_by,
                let createdDate = withQuizletSetSearchResult.created_date,
                let creatorId = withQuizletSetSearchResult.creator_id,
                let editable = withQuizletSetSearchResult.editable,
                let hasAccess = withQuizletSetSearchResult.has_access,
                let hasImages = withQuizletSetSearchResult.has_images,
                let id = withQuizletSetSearchResult.id,
                let langDefinitions = withQuizletSetSearchResult.lang_definitions,
                let langTerms = withQuizletSetSearchResult.lang_terms,
                let modifiedDate = withQuizletSetSearchResult.modified_date,
                let passwordEdit = withQuizletSetSearchResult.password_edit,
                let passwordUse = withQuizletSetSearchResult.password_use,
                let publishedDate = withQuizletSetSearchResult.published_date,
                //let setDescription = withQuizletSetSearchResult.id,
                //let subjects = withQuizletSetSearchResult.subjects,
                let termCount = withQuizletSetSearchResult.term_count,
                let title = withQuizletSetSearchResult.title,
                let url = withQuizletSetSearchResult.url,
                let visibility = withQuizletSetSearchResult.visibility {
                
                self.accessType = Int64(accessType)
                self.canEdit = canEdit
                self.createdBy = createdBy
                self.createdDate = NSDate(timeIntervalSince1970: TimeInterval(createdDate)) //convert date from unix
                self.creatorId = Int64(creatorId)
                self.editable = editable
                self.hasAccess = hasAccess
                self.hasImages = hasImages
                self.id = Int64(id)
                self.langDefinitions = langDefinitions
                self.langTerms = langTerms
                self.modifiedDate = NSDate(timeIntervalSince1970: TimeInterval(modifiedDate)) //convert date from unix
                self.passwordEdit = passwordEdit
                self.passwordUse = passwordUse
                self.publishedDate = NSDate(timeIntervalSince1970: TimeInterval(publishedDate)) //convert from unix
                
                //description is optional or blank
                if let setDescription = withQuizletSetSearchResult.description {
                    self.setDescription = setDescription
                } else {
                    self.setDescription = ""
                }
                //subjects are sent as an array.  For now this will be stored as a string
                if let subjects = withQuizletSetSearchResult.subjects {
                    var subjectString = ""
                    for subject in subjects {
                        //comma delineate
                        if subjectString != "" {
                            subjectString += ", "
                        }
                        //add the member to the string
                        subjectString += String(describing: subject)
                    }
                    self.subjects = subjectString
                } else {
                    self.subjects = ""
                }
                
                self.termCount = Int64(termCount)
                self.title = title
                self.url = url
                self.visibility = visibility
                //Active starts as true
                self.isActive = true
                
            } else {
                //TODO: throw an error because everything wasn't as expected
            }
        } else {
            fatalError("Unable to find Entity name! (QuizletSet)")
        }
        
    }
    
    /******************************************************/
    /*******************///MARK: Fetching Terms
    /******************************************************/
    //TODO: add password support
    //fetches terms, creates QuizletTermDefinitions in the given context
    func fetchTermsAndAddTo(context: NSManagedObjectContext) {
        GCDBlackBox.runNetworkFunctionInBackground {
           
            QuizletClient.sharedInstance.getQuizletSetTermsBy(Int(self.id), termsOnly: true) { (result, error) in
                
                GCDBlackBox.performUIUpdatesOnMain {
                   //results should be a QuizletSetTermsResult
                    
//                    print("Reached CompletionHandler of getQuizletSearchSetsBy")
//                    print("results: \(result)")
//                    print("error: \(error)")
                    if let result = result {
                        //take each term and create
                        for term in result.terms {
                            _ = QuizletTermDefinition(withQuizletTermResult: term, relatedSet: self, context: context)
                        }
                    } else {
                        //TODO: Handle empty response
                    }
                    
                    
                }
            
            }
        }
    }
    
}
