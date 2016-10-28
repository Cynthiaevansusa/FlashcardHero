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
     Connects to Quizlet and downloads urls for photos near the given lat and long
     
     - Parameters:
        - lat: Latitude of desired photos
        - long: Longitude of desired photos
        - radius: number of miles from Lat/Long to search
     
     
     - Returns: An array of photos (as dictionaries)
     */
    func getQuizletSearchNearLatLong(_ lat: Double, long: Double, radius: Double = 5.0, completionHandlerForGetQuizletSearchNearLatLong: @escaping (_ results: Any?, _ error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        var parameters: [String:Any] = [
            QuizletClient.Constants.ParameterKeys.Method: QuizletClient.Constants.Methods.SearchPhotos,
            QuizletClient.Constants.ParameterKeys.Format: QuizletClient.Constants.ParameterValues.ResponseFormat,
            QuizletClient.Constants.ParameterKeys.NoJSONCallback: QuizletClient.Constants.ParameterValues.DisableJSONCallback,
            QuizletClient.Constants.MethodArgumentKeys.PhotosSearch.RadiusUnits: "mi",
            QuizletClient.Constants.MethodArgumentKeys.PhotosSearch.PerPage: 100,
            QuizletClient.Constants.MethodArgumentKeys.PhotosSearch.Page: 1,
            QuizletClient.Constants.MethodArgumentKeys.PhotosSearch.Media: "photos",
            QuizletClient.Constants.MethodArgumentKeys.PhotosSearch.SafeSearch: 1
        ]
        //add passed parameters to parameters dictionary
        //latitude
        parameters[QuizletClient.Constants.MethodArgumentKeys.PhotosSearch.Latitude] = lat
        //longitude
        parameters[QuizletClient.Constants.MethodArgumentKeys.PhotosSearch.Longitude] = long
        //radius
        parameters[QuizletClient.Constants.MethodArgumentKeys.PhotosSearch.Radius] = radius
        
        print("\nAttempting to get Student Locations with the following parameters: ")
        print(parameters)
        
        /* 2. Make the request */
        let _ = taskForGETMethod(parameters: parameters) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForGetQuizletSearchNearLatLong(nil, error)
            } else {
                //json should have returned a A dictionary with a key of "results" that contains an array of dictionaries
                
                if let resultsArray = results?[QuizletClient.Constants.ResponseKeys.Photos] as? [String:AnyObject] { //dig into the JSON response dictionary to get the array at key "photos"
                    
                    print("Unwrapped JSON response from getQuizletSearchNearLatLong:")
                    print (resultsArray)
                    
                    if let photoArray = resultsArray[QuizletClient.Constants.ResponseKeys.Photo] as? [[String:Any]]
                    {
                        print("Array of Photos from getQuizletSearchNearLatLong:")
                        print(photoArray)
//                        //try to put these results into a QuizletPhotoResults struct
                        let QuizletResultsObject = QuizletPhotoResults(fromJSONArrayOfPhotoDictionaries: photoArray)
                        completionHandlerForGetQuizletSearchNearLatLong(QuizletResultsObject, nil)
                    
                        
                    } else {
                        print("\nDATA ERROR: Could not find \(QuizletClient.Constants.ResponseKeys.Photo) in \(resultsArray)")
                        completionHandlerForGetQuizletSearchNearLatLong(nil, NSError(domain: "getQuizletSearchNearLatLong parsing", code: 4, userInfo: [NSLocalizedDescriptionKey: "DATA ERROR: Failed to interpret data returned from Quizlet server (getQuizletSearchNearLatLong)."]))
                    }
                    
                } else {
                    print("\nDATA ERROR: Could not find \(QuizletClient.Constants.ResponseKeys.Photos) in \(results)")
                    completionHandlerForGetQuizletSearchNearLatLong(nil, NSError(domain: "getQuizletSearchNearLatLong parsing", code: 4, userInfo: [NSLocalizedDescriptionKey: "DATA ERROR: Failed to interpret data returned from Quizlet server (getQuizletSearchNearLatLong)."]))
                }
            } // end of error check
        } // end of taskForGetMethod Closure
    } //end getQuizletSearchNearLatLong
}
