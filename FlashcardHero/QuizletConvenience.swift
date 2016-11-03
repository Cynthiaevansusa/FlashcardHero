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
    
    
    /******************************************************/
    /*******************///MARK: FETCHING
    /******************************************************/

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
    func getQuizletSetBy(_ setId: Int, termsOnly: Bool = true, usingPassword: String? = nil, modifiedSince: NSDate? = nil, completionHandlerGetQuizletSearchSetsBy: @escaping (_ results: QuizletGetSetTermsResult?, _ error: NSError?) -> Void) {
        
        //Date validation
        if let modifiedSince = modifiedSince {
            guard (modifiedSince.timeIntervalSince1970 < NSDate().timeIntervalSince1970) else {
                //TODO: Notify user of error
                return
            }
        }
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        var parameters = [String:Any]()
        var mutableMethod: String
        //add passed parameters to parameters dictionary
        
        if let usingPassword = usingPassword {
            
            
            //specify the method
            mutableMethod = QuizletClient.Constants.Methods.GETPasswordProtectedSetById
            
            //use the given setId to mutate the method
            mutableMethod = substituteKeyInMethod(mutableMethod, key: QuizletClient.Constants.MethodArgumentKeys.SetId, value: String(setId))!
            
            //use the given password to mutate the method
            mutableMethod = substituteKeyInMethod(mutableMethod, key: QuizletClient.Constants.MethodArgumentKeys.SetPassword, value: usingPassword)!
            
            //add authentication
            ///TODO: Add parameters for an authenticated session
            
            
        } else {
            //not using a password
            //specify the method

            //check for terms only is true
            if termsOnly {
                mutableMethod = QuizletClient.Constants.Methods.GETSetTermsById
            } else {
                mutableMethod = QuizletClient.Constants.Methods.GETSetById
            }
            
            //use the given setId to mutate the method
            mutableMethod = substituteKeyInMethod(mutableMethod, key: QuizletClient.Constants.MethodArgumentKeys.SetId, value: String(setId))!

        }
        
        //modifiedSince parameter
        if let modifiedSince = modifiedSince {
            parameters[QuizletClient.Constants.ParameterKeys.Search.Sets.ModifiedSince] = modifiedSince.timeIntervalSince1970
        }
        
        /* 2. Make the request */
        let _ = taskForGETMethod(method: mutableMethod, parameters: parameters) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerGetQuizletSearchSetsBy(nil, error)
            } else {
                //json should have returned a A dictionary with a key of "results" that contains an array of dictionaries
//                if termsOnly {
//                    //if request is for terms only, then response will only have a terms key
//                    let responseKeys = QuizletClient.Constants.ResponseKeys.GetSets.SingleSet.Terms
//                } else {
//                    //if request is for set details too, then response will have a terms key
//                    let responseKeys = QuizletClient.Constants.ResponseKeys.GetSets.SingleSet.Terms
//                }
                
         
                
                if let resultsArray = results as? [String:Any] { //dig into the JSON response dictionary to get the array at key "photos"
                    
                    print("Unwrapped JSON response from getQuizletSearchSetsBy:")
                    print(resultsArray)
                    
                    //this should be the result of a search that included terms (termsOnly = false)
                    if !termsOnly {
                        //this is good, create objects from the response
                        //every key except for "terms" which holds the terms is a part of the set
                        let termsDataArray = resultsArray[QuizletClient.Constants.ResponseKeys.GetSets.SingleSet.Terms] as? NSArray
                        
                        //pulled out the terms, now delete that part of the results
                        var setData = resultsArray
                        setData.removeValue(forKey: QuizletClient.Constants.ResponseKeys.GetSets.SingleSet.Terms)
                        //TODO: remove hard coding and handle following
                        setData.removeValue(forKey: "class_ids")
                        
                        //take the raw set and make an object with it
                        var setObject = QuizletSetSearchResult()
                        do {
                            //setObject = try QuizletSetSearchResult(fromDataSet: setData)
                            if let quizletResult = try QuizletSetSearchResult(fromDataSet: setData) {
                                setObject = quizletResult
                            }
                        }
                        catch {
                            //TODO: handle error
                            print("This error needs to be handled")
                        }
                        
                        var termObjectsArray = [QuizletGetTermResult]()
                        //get an array of TermResult objects
                        if let termsDataArray = termsDataArray {
                            for termData in termsDataArray {
                                if let termData = termData as? [String:Any] {
                                    do {
                                        if let termObject = try QuizletGetTermResult(fromDataSet: termData) {
                                            termObjectsArray.append(termObject)
                                        }
                                        
                                    }
                                    
                                    catch {
                                        //TODO: handle error
                                        print("This error needs to be handled")
                                    }
                                }
                            }
                        }
                        
                        //create a QuizletGetSetTermsResult to hold the set and terms
                        
                        let returnSetTerms = QuizletGetSetTermsResult(from: termObjectsArray, set: setObject)
                        
                        completionHandlerGetQuizletSearchSetsBy(returnSetTerms, nil)
                    } else {
                        completionHandlerGetQuizletSearchSetsBy(nil, NSError(domain: "getQuizletSearchSetsBy parsing", code: 4, userInfo: [NSLocalizedDescriptionKey: "DATA ERROR: Expected server response of type NSArray because termsOnly is true."]))
                    }
                    

                    
                   
                    
                } else if let resultsArray = results as? NSArray {
                    print("Unwrapped JSON response from getQuizletSearchSetsBy:")
                    print(resultsArray)
                    
                    if termsOnly {
                        //this is good, create objects from the response
                        //terms only
                        let termsDataArray = resultsArray
                        
                        
                        
                        var termObjectsArray = [QuizletGetTermResult]()
                        //get an array of TermResult objects
                        
                        for termData in termsDataArray {
                            if let termData = termData as? [String:Any] {
                                do {
                                    if let termObject = try QuizletGetTermResult(fromDataSet: termData) {
                                        termObjectsArray.append(termObject)
                                    }
                                    
                                }
                                    
                                catch {
                                    //TODO: handle error
                                    print("This error needs to be handled")
                                }
                            }
                        }
                        
                        //create a QuizletGetSetTermsResult to hold the set and terms
                        
                        let returnSetTerms = QuizletGetSetTermsResult(from: termObjectsArray, set: nil)
                        
                        completionHandlerGetQuizletSearchSetsBy(returnSetTerms, nil)
                    } else {
                        completionHandlerGetQuizletSearchSetsBy(nil, NSError(domain: "getQuizletSearchSetsBy parsing", code: 4, userInfo: [NSLocalizedDescriptionKey: "DATA ERROR: Expected server response of type NSArray because termsOnly is true."]))
                    }
                    
                    //completionHandlerGetQuizletSearchSetsBy(resultsArray, nil)
                
                } else {
                    print("\nDATA ERROR: Could not find \(QuizletClient.Constants.ResponseKeys.Search.ForSets.Sets) in \(results)")
                    completionHandlerGetQuizletSearchSetsBy(nil, NSError(domain: "getQuizletSearchSetsBy parsing", code: 4, userInfo: [NSLocalizedDescriptionKey: "DATA ERROR: Failed to interpret data returned from Quizlet server (getQuizletSearchSetsBy)."]))
                }
            } // end of error check
        } // end of taskForGetMethod Closure
    } //end getQuizletSearchNearLatLong
    
    
    /******************************************************/
    /*******************///MARK: SEARCHING
    /******************************************************/

    
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
    func getQuizletSearchSetsBy(_ searchTerm: String? = nil, modifiedSince: NSDate? = nil, creator: String? = nil, imagesOnly: Bool? = nil, page: Int? = nil, perPage: Int? = nil, completionHandlerGetQuizletSearchSetsBy: @escaping (_ results: [QuizletSetSearchResult]?, _ error: NSError?) -> Void) {
        
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
                    
                    var quizletResultsToReturn = [QuizletSetSearchResult]()
                    
                    for set in resultsArray {
                        //print(set)
                        if let setDictionary = set as? [String:AnyObject] {
                            
                            do {
                                if let quizletResult = try QuizletSetSearchResult(fromDataSet: setDictionary) {
                                    quizletResultsToReturn.append(quizletResult)
                                }
                                
                            }
                            catch {
                                //TODO: handle error
                                print("Error when creating a quizletResult")
                            }
                        }
                    }

                    completionHandlerGetQuizletSearchSetsBy(quizletResultsToReturn, nil)
                    
                } else {
                    print("\nDATA ERROR: Could not find \(QuizletClient.Constants.ResponseKeys.Search.ForSets.Sets) in \(results)")
                    completionHandlerGetQuizletSearchSetsBy(nil, NSError(domain: "getQuizletSearchSetsBy parsing", code: 4, userInfo: [NSLocalizedDescriptionKey: "DATA ERROR: Failed to interpret data returned from Quizlet server (getQuizletSearchSetsBy)."]))
                }
            } // end of error check
        } // end of taskForGetMethod Closure
    } //end getQuizletSearchSetsBy
}
