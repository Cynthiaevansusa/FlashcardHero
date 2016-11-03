//
//  QuizletGetTermResult.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 11/2/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation

struct QuizletGetTermResult {
    
    /******************************************************/
    /*******************///MARK: Properties
    /******************************************************/
    var id : Int?
    var term : String?
    var definition : String?
    var rank : Int?
    
    //TODO: support images
    var image : [String:Any]?
    
    /******************************************************/
    /*******************///MARK: Error Checking Properties
    /******************************************************/
    let expectedKeys : [String] = ["id", "term", "definition", "rank", "image"]
    
    enum QuizletGetTermResultKeyError: Error {
        case badInputKeys(keys: [String]) //couldn't convert incoming dictionary keys to a set of Strings
        case inputMismatchKeys(key: String) //incoming keys don't match expected keys
    }
    enum QuizletGetTermResultAssignmentError: Error {
        case badInputValues(property: String)
        case inputValueOutOfExpectedRange(expected: String, actual: Double)
    }
    
    /******************************************************/
    /*******************///MARK: init
    /******************************************************/
    
    init?(fromDataSet data: [String:Any]) throws {
        //print("\nAttempting to initialize StudentInformation Object from data set")
        
        //try to stuff the data into the properties of this instance, or return nil if it doesn't work
        //check the keys first
        do {
            try checkInputKeys(data)
        } catch QuizletGetTermResultKeyError.badInputKeys (let keys){
            print("\nERROR: Data appears to be malformed. BadInputKeys:")
            print(keys)
            return nil
        } catch QuizletGetTermResultKeyError.inputMismatchKeys(let key) {
            print("\nERROR: InputMismatchKeys. Data appears to be malformed. This key: ")
            print(key)
            print("Do not match the expected keys: ")
            print(expectedKeys)
            return nil
        } catch {
            print("\nQUIZLET PARSING ERROR: Unknown error when calling checkInputKeys")
            return nil
        }
        
        //keys look good, now try to assign the values to the struct
        do {
            try attemptToAssignValues(data)
            //print("Successfully initialized a StudentInformation object\n")
        } catch QuizletGetTermResultAssignmentError.badInputValues(let propertyName) {
            print("\nQUIZLET PARSING ERROR: QuizletGetTermResultAssignmentError: bad input when parsing ")
            print(propertyName)
            return nil
        } catch QuizletGetTermResultAssignmentError.inputValueOutOfExpectedRange(let expected, let actual) {
            print("\nQUIZLET PARSING ERROR: A value was out of the expected range when calling attemptToAssignValues.  Expected: \"" + expected + "\" Actual: " + String(actual))
            return nil
        }catch {
            print("\nQUIZLET PARSING ERROR: Unknown error when calling attemptToAssignValues")
            return nil
        }
    }
    
    //init withiout a data set
    init() {
        //placeholder to allow struct to be initialized without input parameters
    }
    
    /******************************************************/
    /*******************///MARK: Input Checking
    /******************************************************/
    /**
     Verifies that the keys input match the expected keys
     
     - Parameters:
     - data: a `[String:AnyObject]` containing key-value pairs that match `expectedKeys`
     
     - Returns:
     - True: if keys match
     
     - Throws:
     - `QuizletGetTermResultKeyError.BadInputKeys` if input keys can't be made into a set
     - `QuizletGetTermResultKeyError.InputMismatchKeys` if input keys don't match `expectedKeys`
     */
    func checkInputKeys(_ data: [String:Any]) throws {
        //guard check one: Put the incoming keys into a set

        //compare the new set with the expectedKeys
        for key in data.keys {
            if expectedKeys.contains(key) {
                //print("found \(key) in \(expectedKeys)")
            } else {
                throw QuizletGetTermResultKeyError.inputMismatchKeys(key: key)
            }
        }

    }
    
    /**
     Attempts to take a `[String:AnyObject]` and assign it to all of the properties of this struct
     
     - Parameters:
     - data: a `[String:AnyObject]` containing key-value pairs that match `expectedKeys`
     
     - Returns:
     - True: if all values are assigned successfully
     
     - Throws:
     - `QuizletGetTermResultAssignmentError.BadInputValues` if input doesn't have a key in the `expectedKeys` Set
     - `QuizletGetTermResultAssignmentError.inputValueOutOfExpectedRange` if input value at a key that has an expected range is out of range
     */
    private mutating func attemptToAssignValues(_ data: [String:Any]) throws {
        
        //go through each item and attempt to assign it to the struct
        //print("\nAbout to assign values from the following object: ")
        //print(data)
        
        for (key, value) in data {
            switch key {
                
            case "term":
                if let value = value as? String {
                    term = value
                } else {
                    throw QuizletGetTermResultAssignmentError.badInputValues(property: "term")
                }

            case "definition":
                if let value = value as? String {
                    definition = value
                } else {
                    throw QuizletGetTermResultAssignmentError.badInputValues(property: "definition")
                }

            case "id":
                if let value = value as? Int {
                    id = value
                } else {
                    throw QuizletGetTermResultAssignmentError.badInputValues(property: "id")
                }
            case "rank":
                if let value = value as? Int {
                    rank = value
                } else {
                    throw QuizletGetTermResultAssignmentError.badInputValues(property: "rank")
                }
            case "image":
                if let value = value as? [String:Any] {
                    image = value
                } else {
                    //TODO: handle image error
                    //throw QuizletGetTermResultAssignmentError.badInputValues(property: "rank")
                }
            default:
                //unknown input. Should all be ints or strings
                print("Unknown input when initializing FlickrPhoto. Key: \(key), Value: \(value)")
            }
        }
        
    } //end of attemptToAssignValues
    
}
