//
//  QuizletOAuth.swift
//  FlashcardHero
//
//  Created by Jacob Foster Davis on 11/21/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation
import UIKit

extension QuizletClient {
    
    func sendUserToQuizletOAuth(redirect: String? = "", scopes: [String] = ["read"]) {

        // make a string of all the scopes
        var mutableScopes = scopes
        var scopeString = ""
        
        repeat {
            if mutableScopes.count > 0 {
                scopeString += mutableScopes.popLast()!
            }
            
            //insert a space between multiple scopes
            if mutableScopes.count > 0 {
                scopeString += " "
            }
            
        } while mutableScopes.count > 0
        
        //put all parameters in a dictionary
        var parameters = [String:Any]()
        parameters[Constants.ParameterKeys.OAuth.Scope] = scopeString
        parameters[Constants.ParameterKeys.OAuth.ClientID] = Constants.ClientID
        parameters[Constants.ParameterKeys.OAuth.ResponseType] = Constants.ParameterValues.OAuth.ResponseType
        
        //state string for conter CRSF attacks
        let stateString = generateStateString()
        //TODO: save state string for checking when user returns
        
        parameters[Constants.ParameterKeys.OAuth.State] = stateString
        
        //optional redirect after user authenticates.  Default should be stored by Quizlet registerd by API account holder.
        if let redirect = redirect {
            
            //TODO: Save redirect for next OAuth Step
            
            
            parameters[Constants.ParameterKeys.OAuth.RedirectURI] = redirect
        }
        
        
        //form the URL
        var components = URLComponents()
        components.scheme = Constants.OAuthScheme
        components.host = Constants.OAuthHost
        components.path = Constants.OAuthPath
    
        components.queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        //send the user to a default webbrowser with generated URL
        //adapted from http://stackoverflow.com/questions/26704852/osx-swift-open-url-in-default-browser
        if UIApplication.shared.canOpenURL(components.url!) {
            print("About to send the user to Quizlet OAuth URL: " + (components.url?.absoluteString)!)
            UIApplication.shared.open(components.url!)
        } else {
            print("Invalid URL: " + (components.url?.absoluteString)!)
            //TODO: handle invalid URL
        }

        //return components.url!
    }
    
    func generateStateString() -> String {
        return randomString(length: 22)
    }
    
    /******************************************************/
    /*************///MARK: - Generating a random string alphanumeric
    /******************************************************/
    
    //adapted from http://stackoverflow.com/questions/26845307/generate-random-alphanumeric-string-in-swift
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }

    
    
}
