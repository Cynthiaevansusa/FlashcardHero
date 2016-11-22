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
    
    func getQuizletOAuthToken(with code : String, completionHandlerForGetAuthToken: @escaping (_ results: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        //put all parameters in a dictionary
        var parameters = [String:Any]()
        parameters[Constants.ParameterKeys.OAuth.GrantType] = Constants.ParameterValues.OAuth.GrantType
        parameters[Constants.ParameterKeys.OAuth.Code] = code
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: QuizletOAuthTokenURLFromParameters(parameters))
        var AuthString = (String(Secrets.QuizletClientID) + ":" + String(Secrets.QuizletSecretKey)).toBase64()
        print("Created AuthString: \(AuthString)")
        request.addValue("Basic \(AuthString)", forHTTPHeaderField: "Authorization")
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String, code: Int) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGetAuthToken(nil, NSError(domain: "getQuizletOAuthToken", code: code, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError(error!.localizedDescription, code: 1)
                return
            }
            
            //TODO: Use the JSON resonse from Quizlet to give more specific reasons for errors.
            
            /* GUARD: Did we get a 4xx response? */
            guard let statusCode400 = (response as? HTTPURLResponse)?.statusCode , statusCode400 != 400 else {
                switch (response as? HTTPURLResponse)!.statusCode {
                default:
                    sendError("Your request returned a status code of: 400 (Bad Request) \((response as? HTTPURLResponse)!.statusCode).", code: 2)
                }
                
                return
            }
            
            /* GUARD: Did we get a 4xx response? */
            guard let statusCode401 = (response as? HTTPURLResponse)?.statusCode , statusCode401 != 401 else {
                switch (response as? HTTPURLResponse)!.statusCode {
                default:
                    sendError("Your request returned a status code of: 401 (Unauthorized) \((response as? HTTPURLResponse)!.statusCode).", code: 2)
                }
                
                return
            }
            
            /* GUARD: Did we get a 4xx response? */
            guard let statusCode404 = (response as? HTTPURLResponse)?.statusCode , statusCode404 != 404 else {
                switch (response as? HTTPURLResponse)!.statusCode {
                default:
                    sendError("Your request returned a status code of: 404 (Not Found) \((response as? HTTPURLResponse)!.statusCode).", code: 2)
                }
                
                return
            }
            
            /* GUARD: Did we get a 4xx response? */
            guard let statusCode405 = (response as? HTTPURLResponse)?.statusCode , statusCode405 != 405 else {
                switch (response as? HTTPURLResponse)!.statusCode {
                default:
                    sendError("Your request returned a status code of: 405 (Method Not Allowed) \((response as? HTTPURLResponse)!.statusCode).", code: 2)
                }
                
                return
            }
            
            /* GUARD: Did we get a 5xx response? */
            guard let statusCode500 = (response as? HTTPURLResponse)?.statusCode , statusCode500 != 500 else {
                switch (response as? HTTPURLResponse)!.statusCode {
                default:
                    sendError("Your request returned a status code of: 500 (Server Error) \((response as? HTTPURLResponse)!.statusCode).", code: 2)
                }
                
                return
            }
            
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode2xx = (response as? HTTPURLResponse)?.statusCode , statusCode2xx >= 200 && statusCode2xx <= 299 else {
                switch (response as? HTTPURLResponse)!.statusCode {
                default:
                    sendError("Your request returned a status code other than 2xx! Status code \((response as? HTTPURLResponse)!.statusCode).", code: 2)
                }
                
                return
            }
            
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!", code: 3)
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGetAuthToken)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    func QuizletOAuthTokenURLFromParameters(_ parameters: [String:Any]?) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.OAuthScheme
        components.host = Constants.OAuthGetTokenHost
        components.path = Constants.OAuthGetTokenPath
        
        
        if let parameters = parameters {
            components.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        print("About to return an OAuth Token URL: " + (components.url?.absoluteString)!)
        return components.url!
    }
    
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
