//
//  QuizletConvenience.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 10/27/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.

import UIKit
import Foundation

// MARK: - QuizletClient (Convenient Resource Methods)

extension QuizletClient {
    
    /**
     Connects to Quizlet and performs a search for sets based on given criteria.  Search must include searchTerm or creator or both.
     
     - Parameters:
        - searchTerm: A search string
        - modifiedSince: filter for sets modified since this date
        - creator: filter for sets created by the given user id
        - imagesOnly: filter for sets that contain images
        - page: filter for which page of results to return
        - perPage: filter for number of results per page
     
     
     - Returns: An array of JSON sets
     */
    func getQuizletSearchSetsBy(_ searchTerm: String? = nil, modifiedSince: NSDate? = nil, creator: String? = nil, imagesOnly: Bool? = nil, page: Int? = nil, perPage: Int? = nil, completionHandlerGetQuizletSearchSetsBy: @escaping (_ results: NSArray?, _ error: NSError?) -> Void) {
        
        //Date validation
        if let modifiedSince = modifiedSince {
            guard (modifiedSince.timeIntervalSince1970 < NSDate().timeIntervalSince1970) else {
                //TODO: Notify user of error
                return
            }
        }
        
        //Per Page validation
        if let perPage = perPage {
            //per_page must be between 1 and 50
            guard (perPage >= 1 && perPage <= 50) else {
                //TODO: Notify user of error
                return
            }
        }
        
        //Validation: requires either a searchTerm or creator paramerter
        guard searchTerm != nil || creator != nil else {
            //TODO: Nofity user of error
            return
        }
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        var parameters = [String:Any]()
        
        //add passed parameters to parameters dictionary
        
        //search term parameter
        if let searchTerm = searchTerm {
            parameters[QuizletClient.Constants.ParameterKeys.Search.Sets.Query] = searchTerm
        }
        
        //modifiedSince parameter
        if let modifiedSince = modifiedSince {
            parameters[QuizletClient.Constants.ParameterKeys.Search.Sets.ModifiedSince] = modifiedSince.timeIntervalSince1970
        }
        
        //creator parameter
        if let creator = creator {
                parameters[QuizletClient.Constants.ParameterKeys.Search.Sets.Creator] = creator
        }
        
        //imagesOnly conversion to 0 or 1 and parameter
        if let imagesOnly = imagesOnly {
            var imagesOnlyInteger: Int
            if imagesOnly {
                imagesOnlyInteger = 1
            } else {
                imagesOnlyInteger = 0
            }
            
            parameters[QuizletClient.Constants.ParameterKeys.Search.Sets.ImagesOnly] = imagesOnlyInteger
        }
        
        //page parameter
        if let page = page {
            parameters[QuizletClient.Constants.ParameterKeys.Search.Sets.Page] = page
        }
        
        //per page parameter
        if let perPage = perPage {
            parameters[QuizletClient.Constants.ParameterKeys.Search.Sets.PerPage] = perPage
        }
        
        //specify the method
        let method: String = QuizletClient.Constants.Methods.GETSearchForSet

        
        /* 2. Make the request */
        let _ = taskForGETMethod(method: method, parameters: parameters) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerGetQuizletSearchSetsBy(nil, error)
            } else {
                //json should have returned a A dictionary with a key of "results" that contains an array of dictionaries
                
                if let resultsArray = results?[QuizletClient.Constants.ResponseKeys.Search.ForSets.Sets] as? NSArray { //dig into the JSON response dictionary to get the array at key "photos"
                    
                    print("Unwrapped JSON response from getQuizletSearchSetsBy:")
                    print(resultsArray)
                    
//                    if let photoArray = resultsArray[QuizletClient.Constants.ResponseKeys.Photo] as? [[String:Any]]
//                    {
////                        print("Array of Photos from getQuizletSearchSetsBy:")
////                        print(photoArray)
//////                        //try to put these results into a QuizletPhotoResults struct
////                        let QuizletResultsObject = QuizletPhotoResults(fromJSONArrayOfPhotoDictionaries: photoArray)
                        completionHandlerGetQuizletSearchSetsBy(resultsArray, nil)
//
//                        
//                    } else {
//                        print("\nDATA ERROR: Could not find \(QuizletClient.Constants.ResponseKeys.Photo) in \(resultsArray)")
//                        completionHandlerGetQuizletSearchSetsBy(nil, NSError(domain: "getQuizletSearchSetsBy parsing", code: 4, userInfo: [NSLocalizedDescriptionKey: "DATA ERROR: Failed to interpret data returned from Quizlet server (getQuizletSearchSetsBy)."]))
//                    }
                    
                } else {
                    print("\nDATA ERROR: Could not find \(QuizletClient.Constants.ResponseKeys.Search.ForSets.Sets) in \(results)")
                    completionHandlerGetQuizletSearchSetsBy(nil, NSError(domain: "getQuizletSearchSetsBy parsing", code: 4, userInfo: [NSLocalizedDescriptionKey: "DATA ERROR: Failed to interpret data returned from Quizlet server (getQuizletSearchSetsBy)."]))
                }
            } // end of error check
        } // end of taskForGetMethod Closure
    } //end getQuizletSearchNearLatLong
}
