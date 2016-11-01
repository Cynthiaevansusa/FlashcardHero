//
//  QuizletSetSearchResult.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 10/31/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation

struct QuizletSetSearchResult {
    
    /******************************************************/
    /*******************///MARK: Properties
    /******************************************************/
    var access_type : Int?
    var can_edit: Bool?
    var created_by: String?
    var created_date : Int?
    var creator_id : Int?
    var description: String?
    var editable: String?
    var has_access: Bool?
    var has_images: Bool?
    var id : Int?
    var lang_definitions : String?
    var lang_terms : String?
    var modified_date : Int?
    var password_edit: Bool?
    var password_use: Bool?
    var published_date : Int?
    var subjects : NSArray?
    var title: String?
    var url: String?
    var term_count: Int?
    var visibility : String?
    
    /******************************************************/
    /*******************///MARK: Error Checking Properties
    /******************************************************/
    let expectedKeys : [String] = ["access_type", "can_edit", "created_by", "created_date", "creator_id",  "description", "editable", "has_access", "has_images", "id", "lang_definitions", "lang_terms", "modified_date", "password_edit", "password_use", "published_date", "subjects", "term_count", "title", "url", "visibility"]
    
    enum QuizletSetSearchKeyError: Error {
        case badInputKeys(keys: [String]) //couldn't convert incoming dictionary keys to a set of Strings
        case inputMismatchKeys(key: String) //incoming keys don't match expected keys
    }
    enum QuizletSetSearchAssignmentError: Error {
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
        } catch QuizletSetSearchKeyError.badInputKeys (let keys){
            print("\nERROR: Data appears to be malformed. BadInputKeys:")
            print(keys)
            return nil
        } catch QuizletSetSearchKeyError.inputMismatchKeys(let key) {
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
        } catch QuizletSetSearchAssignmentError.badInputValues(let propertyName) {
            print("\nQUIZLET PARSING ERROR: QuizletSetSearchAssignmentError: bad input when parsing ")
            print(propertyName)
            return nil
        } catch QuizletSetSearchAssignmentError.inputValueOutOfExpectedRange(let expected, let actual) {
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
     - `QuizletSetSearchKeyError.BadInputKeys` if input keys can't be made into a set
     - `QuizletSetSearchKeyError.InputMismatchKeys` if input keys don't match `expectedKeys`
     */
    func checkInputKeys(_ data: [String:Any]) throws -> Bool {
        //guard check one: Put the incoming keys into a set
        
        //let keysToCheck = [String](data.keys) as? [String]
        //print("About to check these keys against expected: " + String(keysToCheck))
        //check to see if incoming keys can be placed into a set of strings
//        guard let incomingKeys : Set<String> = keysToCheck.map(Set.init) else {
//            throw QuizletSetSearchKeyError.badInputKeys(keys: [String](data.keys))
//        }
        
        //compare the new set with the expectedKeys
        for key in data.keys {
            if expectedKeys.contains(key) {
                //print("found \(key) in \(expectedKeys)")
            } else {
                throw QuizletSetSearchKeyError.inputMismatchKeys(key: key)
            }
        }
        
//        guard incomingKeys == self.expectedKeys else {
//            throw QuizletSetSearchKeyError.inputMismatchKeys(keys: incomingKeys)
//        }
        
        //print("The following sets appear to match: ")
        //print(self.expectedKeys)
        //print(keysToCheck!)
        
        //Keys match
        return true
    }
    
    /**
     Attempts to take a `[String:AnyObject]` and assign it to all of the properties of this struct
     
     - Parameters:
     - data: a `[String:AnyObject]` containing key-value pairs that match `expectedKeys`
     
     - Returns:
     - True: if all values are assigned successfully
     
     - Throws:
     - `QuizletSetSearchAssignmentError.BadInputValues` if input doesn't have a key in the `expectedKeys` Set
     - `QuizletSetSearchAssignmentError.inputValueOutOfExpectedRange` if input value at a key that has an expected range is out of range
     */
    private mutating func attemptToAssignValues(_ data: [String:Any]) throws -> Bool {
        
        //go through each item and attempt to assign it to the struct
        //print("\nAbout to assign values from the following object: ")
        //print(data)
        
        for (key, value) in data {
            switch key {
                
            case "access_type":
                if let value = value as? Int {
                    access_type = value
                } else {
                    throw QuizletSetSearchAssignmentError.badInputValues(property: "access_type")
                }
            case "can_edit":
                if let value = value as? Int , value == 0 {
                    can_edit = false
                } else if let value = value as? Int , value == 1 {
                    can_edit = true
                } else if String(describing: value) == "1" {
                    can_edit = true
                } else if String(describing: value) == "0" {
                    can_edit = false
                }else {
                    throw QuizletSetSearchAssignmentError.badInputValues(property: "can_edit")
                }
            case "creator_id":
                if let value = value as? Int {
                    creator_id = value
                } else {
                    throw QuizletSetSearchAssignmentError.badInputValues(property: "creator_id")
                }
            case "created_date":
                if let value = value as? Int {
                    created_date = value
                } else {
                    throw QuizletSetSearchAssignmentError.badInputValues(property: "created_date")
                }
            case "editable":
                if let value = value as? String {
                    editable = value
                } else {
                    throw QuizletSetSearchAssignmentError.badInputValues(property: "editable")
                }
            case "has_access":
                print("looking at has_access. value is \"\(value)\"")
                if let value = value as? Int , value == 0 {
                    has_access = false
                } else if let value = value as? Int , value == 1 {
                    has_access = true
                } else if String(describing: value) == "1" {
                    has_access = true
                } else if String(describing: value) == "0" {
                    has_access = false
                }else {
                    throw QuizletSetSearchAssignmentError.badInputValues(property: "has_access")
                }
            case "id":
                if let value = value as? Int {
                    id = value
                } else {
                    throw QuizletSetSearchAssignmentError.badInputValues(property: "id")
                }
            case "has_images":
                if let value = value as? Int , value == 0 {
                    has_images = false
                } else if let value = value as? Int , value == 1 {
                    has_images = true
                } else if String(describing: value) == "1" {
                    has_images = true
                } else if String(describing: value) == "0" {
                    has_images = false
                }else {
                    throw QuizletSetSearchAssignmentError.badInputValues(property: "has_images")
                }
            case "lang_definitions":
                if let value = value as? String {
                    lang_definitions = value
                } else {
                    throw QuizletSetSearchAssignmentError.badInputValues(property: "lang_definitions")
                }
            case "lang_terms":
                if let value = value as? String {
                    lang_terms = value
                } else {
                    throw QuizletSetSearchAssignmentError.badInputValues(property: "lang_terms")
                }
            case "modified_date":
                if let value = value as? Int {
                    modified_date = value
                } else {
                    throw QuizletSetSearchAssignmentError.badInputValues(property: "modified_date")
                }
            case "password_use":
                if let value = value as? Int , value == 0 {
                    password_use = false
                } else if let value = value as? Int , value == 1 {
                    password_use = true
                } else {
                    throw QuizletSetSearchAssignmentError.badInputValues(property: "password_use")
                }
            case "password_edit":
                if let value = value as? Int , value == 0 {
                    password_edit = false
                } else if let value = value as? Int , value == 1 {
                    password_edit = true
                } else {
                    throw QuizletSetSearchAssignmentError.badInputValues(property: "password_edit")
                }
            case "published_date":
                if let value = value as? Int {
                    published_date = value
                } else {
                    throw QuizletSetSearchAssignmentError.badInputValues(property: "published_date")
                }
            case "subjects":
                if let value = value as? NSArray {
                    subjects = value
                } else {
                    throw QuizletSetSearchAssignmentError.badInputValues(property: "subjects")
                }
            case "created_by":
                if let value = value as? String {
                    created_by = value
                } else {
                    throw QuizletSetSearchAssignmentError.badInputValues(property: "created_by")
                }
            case "description":
                if let value = value as? String {
                    description = value
                } else {
                    throw QuizletSetSearchAssignmentError.badInputValues(property: "description")
                }
            case "title":
                if let value = value as? String {
                    title = value
                } else {
                    throw QuizletSetSearchAssignmentError.badInputValues(property: "title")
                }
            case "url":
                if let value = value as? String {
                    url = value
                } else {
                    throw QuizletSetSearchAssignmentError.badInputValues(property: "url")
                }
            case "term_count":
                if let value = value as? Int {
                    term_count = value
                } else {
                    throw QuizletSetSearchAssignmentError.badInputValues(property: "term_count")
                }
            case "visibility":
                if let value = value as? String {
                    visibility = value
                } else {
                    throw QuizletSetSearchAssignmentError.badInputValues(property: "visibility")
                }
            default:
                //unknown input. Should all be ints or strings
                print("Unknown input when initializing FlickrPhoto. Key: \(key), Value: \(value)")
            }
        }
        
        //all values assigned successfully
        return true
    } //end of attemptToAssignValues
    
}
